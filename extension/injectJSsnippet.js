const scriptSrc = document.createElement("script")
scriptSrc.setAttribute("src", "./extension/eventListener.js")
scriptSrc.setAttribute("id", "script#01")
// onMessage.addListener expects a callback function as an argument's value.
chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
	try {
		message = request.message.trim()
		codeInjectStatus = message.split('=')[1].toLowerCase()
		if (codeInjectStatus == "true") {
			document.body.append(scriptSrc)
		} else if (codeInjectStatus == "false") {
			const scriptTag = document.getElementById("script#01")
			const dialogBox = document.getElementById("dialog#01")
			if (scriptTag) {
				document.body.removeChild(scriptTag)
			}
			if (dialogBox) {
				document.body.removeChild(dialogBox)
			}
		}
	} catch (e) {
		console.error("Something Went Wrong", e.message);
	}
});
