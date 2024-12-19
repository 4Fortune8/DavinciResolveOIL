// Create context menu items for images and videos
chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    id: "sendMediaToApi",
    title: "Send URL to Local API",
    contexts: ["image", "video"], // Show menu on right-clicking images or videos
  });

  chrome.contextMenus.create({
    id: 'exit',
    title: 'Exit',
    contexts: ["image", "video"]
  });
});

function makenotifications(title, message) {
  chrome.notifications.create(
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
        chrome.notifications.clear(notificationId);
      }, 3000);
    }
  );
}

// Handle the context menu click
chrome.contextMenus.onClicked.addListener((info) => {
  console.log(info);
  if (info.menuItemId === "sendMediaToApi" && info.srcUrl) {
    const mediaUrl = info.srcUrl; // URL of the image or video
    sendStringToApi('save_image',mediaUrl).then((result) => {
      if (result != "true") {
        console.log(result);
        const title = "Failed To send, check if localhost is running";
        const message =
          "Failed to send media URL. Please check if the local API is running.";
        makenotifications(title, message);
      }
    });
  }
  else if (info.menuItemId === 'exit') {
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
