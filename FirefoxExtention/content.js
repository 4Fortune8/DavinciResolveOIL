let lastRightClickedElement = null;
let lastRightClickedParent = null;

document.addEventListener(
  "contextmenu",
  (event) => {
    lastRightClickedElement = event.target;
    lastRightClickedParent = event.target.parentElement;
  },
  true
);

browser.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.action === "getParentElementData") {
    if (lastRightClickedParent) {
      // Gather the data you need from the parent element. Example:
      const attributes = {};
      for (let attr of lastRightClickedParent.attributes) {
        attributes[attr.name] = attr.value;
      }
      const elementData = {
        srcText: lastRightClickedParent.tagName,
        attributes: attributes,
        outerHTML: lastRightClickedParent.outerHTML,
        innerText: lastRightClickedParent.innerText,
      };
      console.log(elementData.outerHTML);
      const srcMatch = elementData.outerHTML.match(/src="([^"]*)"/);
      console.log(srcMatch[0]);
      console.log(srcMatch[1]);
      const srcText = srcMatch[1];
       console.log(srcText);
  
        const focuedelementData = {
            srcText: srcText,
          };
          sendResponse(focuedelementData);
        }
    // Return true to allow async sendResponse
    return true;
  }
});
