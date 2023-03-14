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
        			document.body.append(popUpBox)
				popUpBox.style.display = "block" // to display the pop up
                        }
                };
                xhr.send()
        } else {
		const popUpBox = document.getElementById("div1")
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

function createLinkTag(link, file) {
	link = document.createElement("link")
	link.setAttribute("rel", "stylesheet")
	link.setAttribute("href", `${file}`)
	return link
}

function createElement(data) {
	// data should be in the form of {key: value}; dictionary
	
	const head = document.getElementsByTagName("head")[0]
	const cssFileLocation = "http://localhost/GrammarlyAlternate/extension/popUpStyle.css"
	var linkSrc = head.querySelector("link") 
	if (!linkSrc) {
		linkSrc = createLinkTag(linkSrc, cssFileLocation)
		document.head.appendChild(linkSrc)
	} else if (linkSrc.getAttribute("href") != cssFileLocation) {
		linkSrc = createLinkTag(linkSrc, cssFileLocation)
		document.head.appendChild(linkSrc)
	}

	const div1 = document.createElement("div")
	div1.setAttribute("id", "div1")
	div1.setAttribute("class", "modal")

	const div2 = document.createElement("div")
	div2.setAttribute("class", "popUpContent")
	div2.setAttribute("style", "width: 300px; height: 300px; margin-left: 990px; margin-top: 10px;")
	
	const span = document.createElement("span")
	span.setAttribute("class", "close")
	span.innerText = "\u00D7" // unicode of &terms; which represent 'x' symbol
	
	const pElement = document.createElement("p")
	
	const label = document.createElement("label")
	for (const key of data) {
		label.append(key)
		label.innerHTML += "<br>"
	}
	pElement.appendChild(label)
	div2.appendChild(span)
	div2.appendChild(pElement)
	div1.appendChild(div2)
	return div1
}

runEvent();
