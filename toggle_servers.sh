#!/bin/bash

function stop_servers() {
	# Find if anything's running on port 8001 (http server)
	# $1 represents the port number
	# tlnp flag = tcp | listening | not resolve port names | programs
	serverService=$(netstat -tlnp | grep $1)
	if [ -n "$serverService" ]; then
		pidOfServer=$(echo $serverService | grep -Po "\d+(?=\/\w+$)")
		if [ -n "$pidOfServer" ]; then
			kill -9 $pidOfServer
			status=$?
			if [ $status -eq 0 ]; then
				echo "$1 was running, stopped now"
			fi
		else
			echo "$1 wasn't running before"
		fi
	fi
}

function start_servers() {
	# Check if the logs directory exist or not
	if [ -e ./logs/ ]; then
		echo -e "./logs/ directory exists\n"
	else
		mkdir ./logs/;
		echo -e "./logs/ Directory created\n"
		echo "All logs will be saved here..."
	fi

	stop_servers 8000 # stop python proxyServer
	stop_servers 8001 # stop python httpServer

	# Start the http server on port 8001
	PYTHONUNBUFFERED=x python -m http.server 8001 -d ./ >> logs/python-http.log 2>&1 &
	httpServerPid=$! # get the PID of the recent ran command i.e., http server
	echo "HTTP Server running.... [$httpServerPid]"

	# Start the python proxy server on port 8000
	PYTHONUNBUFFERED=x python proxyServer.py 8000 >> logs/python-proxyServer.log 2>&1 &
	proxyServerPid=$! # get the PID of the recent run command i.e., proxyServer.py
	echo "Proxy Server running....[$proxyServerPid]"
}

function show_prompt() {
	echo -e "Usage: toggle_servers <START|STOP>\n"
	echo -e "[MODES]"
	echo -e "START : stop any previous running instances, and run HTTP and Proxy server"
	echo -e "STOP  : stop running instances of HTTP and Proxy server\n"

	echo -e "[DESCRIPTION]"
	echo -e "This script runs the python HTTP server and python Proxy server on different-2 ports"
	echo -e "python HTTP Server -> localhost:8001"
	echo -e "python Proxy Server -> localhost:8000"
}

if [ $# -gt 1 ] || [ $# -lt 1 ]; then
	show_prompt
else
	arg1=$(echo $1 | tr '[:upper:]' '[:lower:]') # tr is used to change the case of letters, here we convert from upper to lower
	if [ $arg1 != "start" ] && [ $arg1 != "stop" ]; then
		show_prompt
	else
		if [ $arg1 == "start" ]; then
			start_servers
		else
			stop_servers 8000
			stop_servers 8001
		fi
	fi
fi

