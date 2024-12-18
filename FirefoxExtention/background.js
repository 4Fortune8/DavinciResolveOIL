let mediaRecorder;
let recordedChunks = [];

// Create a context menu item
browser.runtime.onInstalled.addListener(() => {
    browser.menus.create({
    id: "captureTabAudio",
    title: "Capture Tab Audio",
    contexts: ["all"]
  });
});

// Handle the context menu click
browser.menus.onClicked.addListener((info, tab) => {
  if (info.menuItemId === "captureTabAudio") {
    startTabAudioCapture(tab);
  }
});

function startTabAudioCapture(tab) {
    let capturing = browser.tabs.captureVisibleTab();

    // Create MediaRecorder to record the audio stream
    mediaRecorder = new MediaRecorder(capturing);

    mediaRecorder.ondataavailable = (event) => {
      if (event.data.size > 0) {
        recordedChunks.push(event.data);
      }
    };

    mediaRecorder.onstop = async () => {
      const blob = new Blob(recordedChunks, { type: 'audio/webm' });
      recordedChunks = [];

      // Create URL for the blob and prompt user to save it
      const url = URL.createObjectURL(blob);

      // Trigger download to prompt save location
      const saveFileName = `tab-audio-${Date.now()}.webm`;
      browser.downloads.download({
        url: url,
        filename: saveFileName,
        saveAs: true
      });
    };

    // Start recording
    mediaRecorder.start();

    // Stop recording after a certain duration or condition (e.g., user stops it)
    setTimeout(() => {
      mediaRecorder.stop();
    }, 10000); // Example: Stop after 10 seconds
  };