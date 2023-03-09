function highlightText() {
        var selectedText = window.getSelection().toString();
        if (selectedText !== "") {
                var xhr = new XMLHttpRequest();
                xhr.open("GET", "http://localhost:8000?url=https://www.vocabulary.com/dictionary/" + selectedText);
                xhr.onload = function() {
                        if (xhr.readyState === 4 && xhr.status === 200) {
                                var response = xhr.responseText;
                                // Do something with the response
                                alert("I am here")
                        }
                };
                xhr.send()
        }
}

function runEvent() {
        document.addEventListener("mouseup", function() {
                highlightText();
        });
}

runEvent();
