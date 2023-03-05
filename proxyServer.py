import re
import json
import socket
import requests
from requests.structures import CaseInsensitiveDict

LOCAL_HOST = "127.0.0.1"
LOCAL_PORT = 8000


def handle_request(client_sock):
    # Receive data from client
    data = client_sock.recv(4096).decode()
    print(data, end="\n--------\n")

    # Filter out and extract "GET"
    urlParameter = re.search(r"(?<=url=)[\w\S]+", data.split("\n")[0])
    if urlParameter:
        response = requests.get(urlParameter[0])
        if response.status_code in [200, 304]:
            response_headers = bytes(str(response.headers), "utf-8")
            client_sock.send(
                b"HTTP/1.1 200 OK\r\nContent-Type: text/plain; charset=utf-8\r\nAccess-Control-Allow-Origin: *\r\nContent-Length: "
                + bytes(str(len(response.content)), "utf-8")
                + b"\r\n\r\n"
                + response.content
            )
        else:
            client_sock.send(
                b"HTTP/1.1 404 Not Found\r\nContent-Type: text/plain; charset=utf-8\r\nAccess-Control-Allow-Origin: *\r\nContent-Length: 0\r\n\r\n"
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
