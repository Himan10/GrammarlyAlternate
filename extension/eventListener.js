function highlightText() {
        const highlightedText = window.getSelection()
	const selectedText = highlightedText.toString()
        if (selectedText !== "") {
                var xhr = new XMLHttpRequest();
                xhr.open("GET", "http://localhost:8000?url=https://www.vocabulary.com/dictionary/" + selectedText);
                xhr.onload = function() {
                        if (xhr.readyState === 4 && xhr.status === 200) {
                                var response = xhr.responseText;
                                // Do something with the response
                                const parser = new DOMParser() // creates a DOM object
				const htmldoc = parser.parseFromString(response, "text/html") // loads the HTML into the DOM

				// get elements from the recent DOM Object
				const shortDesc = htmldoc.getElementById("short")
				console.log(shortDesc)
				const longDesc = htmldoc.getElementById("long")

				// create the pop up box for displaying the info.
				const popUpBox = createElement([shortDesc, longDesc])

				// get the coordinates of highlighted element
				const coordinates = highlightedText.getRangeAt(0).getBoundingClientRect()

        			document.body.append(popUpBox)
				//popUpBox.showModal(); // to display the pop up
                        }
                };
                xhr.send()
        } else {
		const popUpBox = document.getElementById("div0")
		if (popUpBox) {
			popUpBox.style.display = "none" //change to "block" to redisplay it.
			document.body.removeChild(popUpBox)
		}
	}
}

function runEvent() {
        document.addEventListener("mouseup", function() {
                highlightText();
        });
}

function createElement(data) {
	// data should be in the form of {key: value}; dictionary
	const div0 = document.createElement("div")
	div0.setAttribute("id", "div0")
	const div1 = document.createElement("div")
	div1.setAttribute("style", "overflow: auto; width: 300px; height: 300px")
	div1.setAttribute("id", "div01")
	const div2 = document.createElement("div")
	div2.setAttribute("class", "popUpContent")
	const pElement = document.createElement("p")
	//pElement.setAttribute("style", "width: 300px; height: 350px")
	const label = document.createElement("label")
	for (const key of data) {
		label.append(key)
		label.innerHTML += "<br>"
	}
	pElement.appendChild(label)
	div2.appendChild(pElement)
	div1.appendChild(div2)
	div0.appendChild(div1)
	return div0
}

runEvent();
