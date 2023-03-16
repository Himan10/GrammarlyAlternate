# What's this repo. for? 

This repository demonstrates the working of one of the features provided by grammarly through their web extension. However, It doesn't work exactly like that feature but I've tried my best to implement the same in a very basic and raw style. In the end, This repository is just an experimentation with JS, HTML/CSS and Python, also another half of this repository belongs to secure coding practices and vulnerabilites that might be present in the code structure of this repo. I have not yet found or started finding any vulnerabilities in this, soon I'll. 

Little did I know about grammarly is, basically, ***[Grammarly](https://www.grammarly.com)*** is like your english teacher or a friend that suggests if there's any error, mispelled word or incorrect sentences. It can even help you to find out meanings of words or phrases.  

I've been using their add-on since 2019, and it has helped me a lot even since. Recently, I was using one of its features that pops up meaning of a word/phrase, and I found it little fascinating, honeslty speaking, so I found it very simple. I decided to give it a try, and this repo. is built specially for that purpose. 

# How this works? 

The functiionality provided by grammarly's web extension works like this.    

On a web page, if you select any word by double-clicking on it, the extension will pop-up a card containing meanings and explanations of that selected word or phrase. The coordinates of this pop-up card depends on the position of the selected word, if you're selecting a word from the bottom of the page, the pop-up card will appear little above the word, and vice-versa. As shown in the image below, the defintions, terms etc. are retrived from wikitionary.   

For example:    
![Grammarly extension pop-up card example](https://www.imgur.com/vnnIe9U.jpg)    

In my case, it's derived from the same behavior of selecting a text by double-clicking and showing the relevant results except the output is shown on the right side of the web page, with fixed position and certain width and height.    

For example:    
![GrammarlyAlternate extension pop-up card example](https://imgur.com/XdwJ97N.jpg)    

Okay! so I guess that's all about **Grammarly Extension** (left) & **GrammarlyAlternate Extension** (right) basic functionality.    

### Some internals about GrammarlyAlternate -
![GrammarlyAlternate background working](https://imgur.com/x6iXQRY.png)    
I'll add more to this section in the upcoming README changes ~running out of time & battery~.

# Installation
**NOTE**: *This project works only in localhost as of now, don't try it on any other web pages due to partial development and testing.*  

* ***DOWNLOAD this repository*** - Steps, you should know how to use git clone.    

* ***INSTALL the extension*** - I am running brave browser, so here, the steps are quite simple. Go to `chrome://extensions` -> Click the "Load Unpacked" option -> Select the GrammarlyAlternate directory, go to sub directory "extension/", and select the `manifest.json` file.    

* ***RUN a HTTP server*** - Run a HTTP server on your local machine, and host this directory contents.    
To do that, run this commend -> `python -m http.server <portNumber> --directory <path/to/GrammarlyAlternate>`    
Remember, do not use the same port number on which the proxyServer.py will be running. 

* ***RUN the python script*** - Run the proxyServer.py using python. You can also run the script in the background as well.

* Once the above steps are completed, and you see the GrammarlyAlternate extension loaded on the navigation bar, you're almost done.     

* The button on web extension supports toggle functionality. You can inject the code by clicking on "inject" and extract the piece of injected code by clicking on "Extract".

* Go to the localhost, select the GrammarlyAlternate dir and open the file `useMeForTest.html`. 

* Now click on the extension and inject the javascript code, select any word and you'll get the output at the right side of your web page.

### Additionals
I've created a python script to get the information about given word in the CLI. In order to use that, check out `/GrammarlyAlternate/grammarlyAlternatePy.py`.    
    

Will add more in here. 
