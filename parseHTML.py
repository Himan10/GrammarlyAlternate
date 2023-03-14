from bs4 import BeautifulSoup
from jinja2 import Template

def extractTagFromHTML(html_body):
    
    #create a bs4 object
    soup = BeautifulSoup(html_body, "html.parser")

    #find all the <p> tags
    shortDescription = soup.find('p', class_="short")
    longDescription = soup.find('p', class_="long")
    return HTMLTemplate(shortDescription.getText(), longDescription.getText())

def HTMLTemplate(shortDesc, longDesc):
    # create template
    template = Template("""<html>
<head>
<title>Word Description</title>
</head>
<body>
<p id="short"><b><i>Short Description :</b>{{ shortDesc }}</i><br></p>
<p id="long"><b><i>Long Description :</b>{{ longDesc }}</i><br></p>
</body>
</html>
""")

    return template.render(shortDesc=shortDesc, longDesc=longDesc)
