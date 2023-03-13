const buttonEvent = document.getElementById("button-tag")
buttonEvent.addEventListener("click", () => {
	const buttonStatus = buttonEvent.innerText.toLowerCase()
	if (buttonStatus == "inject") {
		sendMessageToContentScript("CodeInjected=true");
		buttonEvent.innerText = "Extract"
	} else if (buttonStatus == "extract") {
		sendMessageToContentScript("CodeInjected=false");
		buttonEvent.innerText = "Inject"
	}
});

function sendMessageToContentScript(text_message) {
	chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
		chrome.tabs.sendMessage(tabs[0].id, {message: text_message});
	});
}
