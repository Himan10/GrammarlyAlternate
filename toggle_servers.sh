#!/bin/bash

function stop_servers() {
	# Find if anything's running on port 8001 (http server)
	# $1 represents the port number
	# tlnp flag = tcp | listening | not resolve port names | programs
	serverService=$(ss -tlnp | grep $1)
	if [ -n "$serverService" ]; then
		pidOfServer=$(echo $serverService | grep -Po "(?<=pid=)\d+")
		if [ -n "$pidOfServer" ]; then
			kill -9 $pidOfServer
			status=$?
			if [ $status -eq 0 ]; then
				echo -e "$1 was running, stopped now"
			fi
		else
			echo "$1 wasn't running before"
		fi
	else
		echo -e "Nothing is running on port $1"
	fi

}

function start_servers() {
	# Check if python is present or not
	if python --version >/dev/null 2>&1; then echo ; else echo -e "Python is not installed\nSet alias if it's present (for ex. alias python=python3.10)"; exit 1; fi

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

	echo -e "\n"
	# Start the http server on port 8001
	PYTHONUNBUFFERED=x python -m http.server 8001 -d ./ >> logs/python-http.log 2>&1 &
	httpServerPid=$! # get the PID of the recent ran command i.e., http server
	[ $? != 0 ] && echo -e "\033[0;31mFailed running HTTP Server\033[0m" ||  echo "HTTP Server [$httpServerPid] running on 8001"

	# Start the python proxy server on port 8000
	PYTHONUNBUFFERED=x python proxyServer.py 8000 >> logs/python-proxyServer.log 2>&1 &
	proxyServerPid=$! # get the PID of the recent run command i.e., proxyServer.py
	[ $? != 0 ] && echo -e "\033[0;31mFailed running Proxy Server\033[0m" || echo "Proxy Server [$proxyServerPid] running on 8000"
}

function show_prompt() {
	echo -e "Usage: toggle_servers <START|STOP|CLEAR>\n"
	echo -e "[MODES]"
	echo -e "START : stop any previous running instances, and run HTTP and Proxy server"
	echo -e "STOP  : stop running instances of HTTP and Proxy server"
	echo -e "CLEAR : clear the logs present under logs directory for better readability and monitoring\n"

	echo -e "[DESCRIPTION]"
	echo -e "This script runs the python HTTP server and python Proxy server on different-2 ports"

	echo -e "python HTTP Server -> localhost:8001"
	echo -e "python Proxy Server -> localhost:8000"
}

function clear_logs() {
	httpLogFile="logs/python-http.log"
	proxyServerLogFile="logs/python-proxyServer.log"
	if [ -e "logs/" ]; then
		[ -e "$httpLogFile" ] && (truncate -s 0 "$httpLogFile" && echo "Removed contents from $httpLogFile") || echo -e "\033[0;31mFAILED... (file not found $httpLogFile)\033[0m"
		[ -e "$proxyServerLogFile" ] && (truncate -s 0 "$proxyServerLogFile" && echo "Removed contents from $proxyServerLogFile") || echo -e "\033[0;31mFAILED...(file not found $proxyServerLogFile)\033[0m"
	else
		echo "\"logs/\" directory not found"
	fi
}

if [ $# -gt 1 ] || [ $# -lt 1 ]; then
	show_prompt
else
	arg1=$(echo $1 | tr '[:upper:]' '[:lower:]') # tr is used to change the case of letters, here we convert from upper to lower
	if [ $arg1 != "start" ] && [ $arg1 != "stop" ] && [ $arg1 != "clear" ]; then
		show_prompt
	else
		if [ $arg1 == "start" ]; then
			start_servers
		elif [ $arg1 == "stop" ]; then
			stop_servers 8000
			stop_servers 8001
		elif [ $arg1 == "clear" ]; then
			clear_logs
		fi
	fi
fi

