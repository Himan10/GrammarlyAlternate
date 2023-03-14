#!/usr/bin/python3.10

import types
import requests
from sys import argv
from re import match
from bs4 import BeautifulSoup
from pynput import keyboard
from functools import partial
from colorama import Fore, Style

class Keys(object):
    """ Class containing two static method utility functions
    staticmethod : much more like a normal function
    * Knows nothing about class or not depends on state of obj.
    * Class/Obj.staticmethodutilityfunction()
    """
    
    @staticmethod
    def on_keypress(key):
        pass

    @staticmethod
    def on_keyrelease(key, obj):
        if key == keyboard.KeyCode.from_char('n'):
            try:
                print(next(obj))
            except StopIteration:
                return False
        elif key == keyboard.KeyCode.from_char('q'):
            print('Quit')
            return False

class KeyListener(Keys):

    def __init__(self, obj):
        if isinstance(obj, types.GeneratorType):
            self.obj = obj
        else:
            raise Exception(f" Passed {obj!r} isn't generator")
        on_keyrelease = partial(Keys.on_keyrelease, obj=self.obj)
        self._listener = keyboard.Listener(
                on_press = Keys.on_keypress,
                on_release = on_keyrelease,
                suppress=True
        )

    def listen(self):
        self._listener.start()
        while self._listener.running:
            self._listener.join()
        self._listener._suppress=False
        self._listener.stop()

class Vocab:

    def __init__(self):
        self.conn = 0
        self.descp = ["short", "long"]
        self.url = "https://www.vocabulary.com/dictionary/{0}"
        self.word = ''
        self._source = ''

    def fetchpage(self, word: str) -> None:
        self.word = word
        self._source = requests.get(self.url.format(self.word))
        if self._source.ok and self._source.status_code == 200:
            self.conn = self._source.status_code
        else:
            raise Exception(f"Conn. isn\'t possible [{source.conn}]")

    def getdata(self) -> None:
        # parse html document
        soup = BeautifulSoup(self._source.text, "html.parser")
        short = soup.find('p', class_="short")
        if short:
            self.descp[0] = short.getText()
        long = soup.find('p', class_="long")
        if long:
            self.descp[1] = long.getText()
        #link = soup.find_all('p') # find all the tags with <p>
        #if link:
        #    for i in range(len(self.descp)):
        #        self.descp[i] = link[i].text
        #else:
        #    self.descp = ['', '']

        if all(i=='' for i in self.descp):
            raise Exception("Nothing Found")
    
    def prettyprint(self) -> None:

        def yieldline(data: str):
            temp = ' '
            n = 0
            for i in range(len(data)):
                if data[i] == ' ' and n+1 == 10:
                    yield temp
                    temp = ''
                    n = 0
                elif data[i] == ' ' and n+1 != 10:
                    n += 1
                temp += data[i]
                if i == len(data)-1 and n < 10:
                    yield temp

        def printline(data: str):

            a = yieldline(data)
            k = KeyListener(a)
            i = 0
            for _ in range(5):
                try:
                    print(next(a))
                except StopIteration:
                    return

            k.listen()
       
        print("\nPrint \'n\' for next lines & \'q\' for Quit!", end="\n-------------------\n")
        print(f"{Fore.LIGHTBLUE_EX}Short Description : {Style.RESET_ALL}")
        printline(self.descp[0])
        print('\n')
        print(f"{Fore.LIGHTBLUE_EX}Long Description : {Style.RESET_ALL}")
        printline(self.descp[1])


def ScrapeMeaning():
    """
Usage : python <filename> word
Python version : 3.0+
Word type : string (or "str")
    """
    if len(argv) < 2:
        print(ScrapeMeaning.__doc__)
    elif len(argv) == 2:
        if match(r'^[\d\W]+', argv[1]):
            return print("Pass a Proper Word")
        try:
            v = Vocab()
            v.fetchpage(argv[1])
            v.getdata()
            v.prettyprint()
        except Exception as e:
            print(e.args[0])

ScrapeMeaning()
