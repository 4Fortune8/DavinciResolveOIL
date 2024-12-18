from flask import Flask, request, jsonify
import requests
from pytubefix import YouTube
from pytubefix.cli import on_progress
import mimetypes

from urllib.parse import urlparse, urlunparse
import re
import importlib.util

spec = importlib.util.spec_from_file_location('DaVinciResolveScript', 'C:/ProgramData/Blackmagic Design/DaVinci Resolve/Support/Developer/Scripting/Modules/DaVinciResolveScript.py')
dvr_script = importlib.util.module_from_spec(spec)
spec.loader.exec_module(dvr_script)

print("dvr_script",dvr_script)

app = Flask(__name__)

@app.route('/receive_url', methods=['POST'])
def receive_text():
    data = request.get_json()
    print("data",data)
    text = data.get('url', '')
    response = {
        'received_text': text,
        'message': 'url received successfully'
    }
    print(response)
    handle_url(response['received_text'])
    return jsonify(response)


def handle_url(url):
    print("url",url)
    parsed_url = urlparse(url)
    clean_url = urlunparse(parsed_url._replace(query=''))
    mime_type, _ = mimetypes.guess_type(clean_url)
    if mime_type:
        if mime_type.startswith('image'):
            downloadfile(clean_url, 'image')
        elif mime_type.startswith('video') or mime_type.startswith('audio'):
            downloadfile(clean_url, 'video')
        else:
            print("Unsupported file type")
    else:
        print("Could not determine the file type")
    return "Downloaded"

def sanitize_filename(filename):
    return re.sub(r'[^\w\-_\. ]', '_', filename)


def downloadfile( url,type):
    print("url",url)    
    print(url)
    sanitized_url = sanitize_filename(url)

    if type == "video":
        response = requests.get(url, stream=True)
        with open(sanitized_url, 'wb') as f:
            for chunk in response.iter_content(chunk_size=1024):
                if chunk:
                    f.write(chunk)
        print("Done vid")   
    elif type == "image":
        response = requests.get(url)

        with open(sanitized_url, 'wb') as f:
            f.write(response.content)
        print("Done img")


if __name__ == '__main__':
    app.run(debug=True)