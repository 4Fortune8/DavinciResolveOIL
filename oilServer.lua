local socket = require("ljsocket")
local json = require("dkjson")
local ffi = require("ffi")

local os_name = ffi.os
print("Operating System: " .. os_name)

-- OS-specific setup
if os_name == "Windows" then
    ffi.cdef [[
        typedef wchar_t WCHAR;

        int MultiByteToWideChar(
            unsigned int CodePage,
            unsigned long dwFlags,
            const char* lpMultiByteStr,
            int cbMultiByte,
            WCHAR* lpWideCharStr,
            int cchWideChar);

        void* _wfopen(const WCHAR* filename, const WCHAR* mode);
        size_t fread(void* buffer, size_t size, size_t count, void* stream);
        int fclose(void* stream);
        void Sleep(unsigned int ms);
        int ShellExecuteA(void* hwnd, const char* lpOperation, const char* lpFile,
                          const char* lpParameters, const char* lpDirectory, int nShowCmd);
    ]]
elseif os_name == "OSX" or os_name == "Linux" then
    ffi.cdef [[ int system(const char *command); ]]
else
    print("Unsupported OS: " .. tostring(os_name))
    return
end

-- Resolve / Fusion API setup
fusion = resolve:Fusion()
project = resolve:GetProjectManager():GetCurrentProject()
mediaPool = project:GetMediaPool()
rootFolder = mediaPool:GetRootFolder()
currentProject = project:GetName()

-- Helpers
function sanitize_filename(filename)
    return filename:gsub("[^%w%-_%. ]", "_")
end

function download_file(url, getfilepath)
    -- Try to extract the real filename (last path segment before query)
    local basename = url:match("([^/]+)%?") or url:match("([^/]+)$") or "download.mp4"

    -- Ensure we have an extension
    if not basename:match("%.[%a%d]+$") then
        basename = basename .. ".mp4"
    end

    -- Sanitize for filesystem
    local safe_name = sanitize_filename(basename)

    local outpath = string.format('%s/%s', getfilepath, safe_name)
    local cmd = string.format('curl --create-dirs -L -o "%s" "%s"', outpath, url)
    print("Running:", cmd)
    os.execute(cmd)

    return outpath
end


function sleep(n)
    if os_name == "Windows" then
        ffi.C.Sleep(n * 1000)
    else
        os.execute("sleep " .. tonumber(n))
    end
end

function receive_text(data)
    local text = data.releventString or ""
    local response = { url = text, message = "url received successfully" }
    print(response)
    return response
end

-- HTTP server setup
local port = 55500
local info = socket.find_first_address("*", port)
local server = assert(socket.create(info.family, info.socket_type, info.protocol))
print("AutoSubs server is listening on port:", port)

server:set_blocking(false)
assert(server:set_option("nodelay", true, "tcp"))
assert(server:set_option("reuseaddr", true))
assert(server:bind(info))
assert(server:listen())

function CreateResponse(body)
    local header = "HTTP/1.1 200 OK\r\n" ..
                   "Server: ljsocket/0.1\r\n" ..
                   "Content-Type: application/json\r\n" ..
                   "Content-Length: " .. #body .. "\r\n" ..
                   "Connection: close\r\n" ..
                   "Access-Control-Allow-Origin: *\r\n" ..
                   "Access-Control-Allow-Methods: GET, POST, OPTIONS\r\n" ..
                   "Access-Control-Allow-Headers: Content-Type\r\n\r\n"
    return header .. body
end

function AddMediaToBin(url, filePath)
    print("Adding media to bin")
    local mediaStorage = resolve:GetMediaStorage()
    local oldFiles = {}
    for _, record in ipairs(mediaStorage:GetFileList(filePath)) do
        oldFiles[record] = true
    end

    -- Download and capture the saved file path
    local savedFile = download_file(url, filePath)

    local newFiles = mediaStorage:GetFileList(filePath)
    for _, newRecord in ipairs(newFiles) do
        if not oldFiles[newRecord] then
            mediaStorage:AddItemListToMediaPool(newRecord)
            print("New record found:", newRecord)
        end
    end
end

function refreshProject()
    print("Refreshing Resolve project context")
    fusion = resolve:Fusion()
    project = resolve:GetProjectManager():GetCurrentProject()
    mediaPool = project:GetMediaPool()
    rootFolder = mediaPool:GetRootFolder()
    currentProject = project:GetName()
end

local oldfilePath = ''
function startCooking()
    print("[AutoSubs Server] Cooked With OIL")
    local mountedVolumeList = resolve:GetMediaStorage():GetMountedVolumes()
    local rootFolder = mountedVolumeList[1]
    local currentProject = project:GetName()
    local filePath = rootFolder .. '/' .. currentProject

    if oldfilePath ~= filePath then
        print("Creating dir:", filePath)
        os.execute('mkdir -p "' .. filePath .. '"')
        oldfilePath = filePath
    end
    return filePath
end

-- Main server loop
local quitServer = false
while not quitServer do
    if not resolve then
        print("DaVinci Resolve is not running. Shutting down server...")
        quitServer = true
        break
    end

    local client, err = server:accept()
    if client then
        local peername = client:get_peer_name()
        if peername then
            assert(client:set_blocking(false))
            local str = client:receive()
            if not project:GetName() then
                refreshProject()
                sleep(0.2)
            end

            if str then
                print("Received request:", str)
                local content = str:match("\r\n\r\n(.*)")
                print("Content:", content)

                local data, _, err = json.decode(content or "", 1, nil)
                local body = ""

                local success, perr = pcall(function()
                    if not data then
                        body = json.encode({ message = "Invalid JSON data" })
                    elseif data.func == "save_image" or data.func == "save_alternative" then
                        local filePath = startCooking()
                        AddMediaToBin(data.releventString, filePath)
                        body = json.encode({ message = "Job completed" })
                    elseif data.func == "Exit" then
                        print("Exiting server")
                        quitServer = true
                        body = json.encode({ message = "Job completed" })
                    else
                        body = json.encode({ message = "Invalid function name" })
                    end
                end)

                if not success then
                    body = json.encode({ message = "Job failed: " .. tostring(perr) })
                end

                local response = CreateResponse(body)
                assert(client:send(response))
                client:close()
            else
                client:close()
            end
        end
    elseif err and err ~= "timeout" then
        error(err)
    end

    sleep(1)
end

print("Shutting down AutoSubs server...")
server:close()
print("Server shut down.")
