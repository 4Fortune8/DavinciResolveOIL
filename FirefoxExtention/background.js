// Create context menu items for images and videos
browser.runtime.onInstalled.addListener(() => {
  browser.contextMenus.create({
    id: "sendMediaToApi",
    title: "Send URL to Local API",
    contexts: ["image", "video"], // Show menu on right-clicking images or videos
  });

  browser.contextMenus.create({
    id: 'exit',
    title: 'Exit',
    contexts: ["image", "video"]
  });
});

function makenotifications(title, message) {
  browser.notifications.create(
    {
      type: "basic",
      iconUrl: "images/icon-128x128.png",
      title: title,
      message: message,
      priority: 2,
    },
    (notificationId) => {
      // Clear the notification after 3 seconds
      setTimeout(() => {
        browser.notifications.clear(notificationId);
      }, 3000);
    }
  );
}


// Handle the context menu click
browser.contextMenus.onClicked.addListener(async (info, tab) => {
  console.log(info);
  if (info.menuItemId === "sendMediaToApi") {
    if (info.srcUrl && info.srcUrl.trim() !== "") {
      // srcUrl is present, send it to API as before
      const mediaUrl = info.srcUrl;
      sendStringToApi('save_image', mediaUrl).then((result) => {
        if (result != "true") {
          console.log(result);
          const title = "Failed To send, check if localhost is running";
          const message =
            "Failed to send media URL. Please check if the local API is running.";
          makenotifications(title, message);
        }
      });
    } else {
      // srcUrl is empty, request parent element data from content script
      const response = await browser.tabs.sendMessage(tab.id, { action: "getParentElementData" });
      console.log(response)
      console.log(response.srcText)
      if (response && response.srcText) {
        // You now have the parent element's data
        console.log("Parent Element Data:", response.srcText);
        
        // Extract some string from the parent element if needed. For example:
        // Let’s say we decide to send the parent’s outerHTML to the API.
        const parentOuterHTML = response.srcText;
        
        sendStringToApi('save_alternative', parentOuterHTML).then((result) => {
          if (result != "true") {
            console.log(result);
            const title = "Failed To send parent element data, check if localhost is running";
            const message =
              "Failed to send parent element data. Please check if the local API is running.";
            makenotifications(title, message);
          }
        });
      } else {
        console.log("No parent element data returned.");
      }
    }
  } else if (info.menuItemId === 'exit') {
    exit().then((result) => {
      if (result != "true") {
        console.log(result);
        const title = "Failed To exit, check if localhost is running";
        const message =
          "Failed to exit. Please check if the local API is running.";
        makenotifications(title, message);
      }
    });
  }
});

browser.runtime.onMessage.addListener((message, sender, sendResponse) => {
 if (message.action === "save_name") {
    sendStringToApi('save_video',message.saveName).then((result) => {
      if (result != "true") {
        console.log(result);
        const title = "Failed To send filename, check if localhost is running";
        const message =
          "Failed to send filename. Please check if the local API is running.";
        makenotifications(title, message);
      }
    });
  }
});

function exit() {
  const apiUrl = `http://localhost:55500`; // Replace with your local API endpoint
  console.log("Sending exit to API:", apiUrl);
  return fetch(apiUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ 
      func: 'Exit',
      }),
  })
    .then((response) => {
      if (response.ok) {
        console.log("stringSent sent successfully!");
        return "true";
      } else {
        console.error("Failed to send stringSent:", response.status);
        return response.status;
      }
    })
    .catch((error) => {
      console.error("Error:", error);
      return error;
    });
}
function sendStringToApi(apiPath,stringSent) {
  const apiUrl = `http://localhost:55500`; // Replace with your local API endpoint
  console.log("Sending stringSent to API:", apiUrl);
  return fetch(apiUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ 
      func: 'save_image',
      releventString: stringSent }),
  })
    .then((response) => {
      if (response.ok) {
        console.log("stringSent sent successfully!");
        return "true";
      } else {
        console.error("Failed to send stringSent:", response.status);
        return response.status;
      }
    })
    .catch((error) => {
      console.error("Error:", error);
      return error;
    });
}
