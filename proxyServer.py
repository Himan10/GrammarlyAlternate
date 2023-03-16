import re
import json
import socket
import requests
import urllib.parse
from parseHTML import extractTagFromHTML

LOCAL_HOST = "127.0.0.1"
LOCAL_PORT = 8000

def urlEncoding(value):
    if len(value) > 1 and not value.isspace():
        # Perform url-decoding on the url-encoded strings
        value = urllib.parse.unquote(value)
        # Remove any non-white space & non-alphanumeric characters
        value = re.sub(r"[^\s\w]", "", value).strip()
        # is a single word?
        if len(value) > 1 and value.find(" ") < 1:
            # Yes, a single word
            return value, True
    return value, False


def handle_request(client_sock):
    # Receive data from client
    data = client_sock.recv(4096).decode()

    # Filter out and extract "GET"
    urlParameter = re.search(
        r"(?<=\?url=)(https?:\/\/www.vocabulary.com\/dictionary\/)([\w\S]*)",
        data.split("\n")[0],
    )
    print(urlParameter)
    try:
        if urlParameter:
            url, phrase = urlParameter.groups()
            phrase, processWord = urlEncoding(phrase)
            response = requests.get(url + phrase)
            if response.status_code in [200, 304]:
                response_headers = bytes(str(response.headers), "utf-8")
                if processWord:
                    response_strContent = extractTagFromHTML(response.text)
                else:
                    response_strContent = "No Word Selected"
                client_sock.send(
                    b"HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nAccess-Control-Allow-Origin: *\r\nContent-Length: "
                    + bytes(str(len(response_strContent)), "utf-8")
                    + b"\r\n\r\n"
                    + response_strContent.encode("utf-8")
                )
            else:
                client_sock.send(
                    b"HTTP/1.1 404 Not Found\r\nContent-Type: text/plain; charset=utf-8\r\nAccess-Control-Allow-Origin: *\r\nContent-Length: 0\r\n\r\n"
                )
    except:
        client_sock.send(
            b"HTTP/1.1 500 Internal Server Error\r\nContent-Type: text/plain; charset=utf-8\r\nAccess-Control-Allow-Origin: *\r\nContent-Length: 0\r\n\r\n"
        )


def main():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server_sock:

        # set the SO_REUSEADDR option; This helps in reducing OSError: Already in use
        server_sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

        server_sock.bind((LOCAL_HOST, LOCAL_PORT))
        server_sock.listen()

        print(f"Proxy server listening on {LOCAL_HOST}:{LOCAL_PORT}")

        while True:
            client_sock, client_addr = server_sock.accept()

            print("Accepted request from : ", client_addr)
            handle_request(client_sock)
            client_sock.close()

        server_sock.close()


if __name__ == "__main__":
    main()
