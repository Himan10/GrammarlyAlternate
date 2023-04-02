function description() {
	echo -e "\nGenerate ssl certificates for better communication Between server\nand the client\n"
	echo -e "This is necessary because the python proxy server running on AWS expects\na secure communication, for that, all the calls that will be made to the\npython proxy server will be carried forward with HTTPs along with TLS."
}

function commandUsage() {
	echo -e "Usage: generatecerts <SERVER|CLIENT>\n"
	echo -e "[CLI Arguments]"
	echo -e "SERVER: Generate certs for server, this command with \"server\" argument\nshould be run on AWS/GCP or wherever you've access to.\nAll Files will be saved with prefix \"server\" under \"certs/\" dir., for example: server.crt"

	echo -e "\nCLIENT: Generate certs for client, this command with \"client\" argument\nshould be run on local machines.\nFiles will be saved with prefix \"client\" under \"certs/\" dir., for example: client.srt"

	description
}

function checkExitStatus() {
	# Define color codes
	RED="\033[0;31m"
	GREEN="\033[0;32m"
	NC="\033[0m"

	if [ "$1" -eq 0 ]; then
		echo -e "${GREEN}$2\n${NC}"
		sleep 0.5
	else
		echo -e "${RED}Error in \"$2\" process${NC}"
	fi
}

function getFileFromHost() {
	# copy the server cert to /etc/ssl/certs
	read -p "Enter the host address (Ex. AWS/GCP) : " "host_address"

	# enter the server.crt file present on the host
	read -p "Enter the file location : " "file_location"

	# make connection and download the file from the server
	read -p "Enter the location of .pem credentials : " "pem_file"

	scp -i "$pem_file" "$host_address":"$file_location/server.crt" "./certs/"
	if [ $? != 0 ]; then
		echo -e "Something went wrong\nRe-check the provided inputs"
	else
		echo -e "\"server.crt\" is present under certs/"
	fi
}

function generate_certs() {
	# Create the directory and send client/server cert req. to there
	mkdir "certs/"

	# Generate the keys
	openssl genrsa -out "$1.key" 2048
	checkExitStatus "$?" "Key Generated Successfully"
	cp "$1.key" "certs/"

	# Generate the csr (certificate signing registry)
	openssl req -new -key "$1.key" -out $1.csr;
	checkExitStatus "$?" "CSR Generated Successfully"
	cp "$1.csr" "certs/"

	# Generate the crt (certificate)
	openssl x509 -req -in "$1.csr" -signkey "$1.key" -out "$1.crt";
	checkExitStatus "$?" "Certificate Generated Successfully"
	cp "$1.crt" "certs/"

	# server.crt file location
	read -p "server.crt on present (local / cloud ) : " "user_choice"
	user_choice=$(echo "$user_choice" | tr "[:upper:]" "[:lower:]")
	fileLocation="./certs/server.crt"

	if [ $user_choice == "cloud" ]; then
		getFileFromHost
	else
		read -p "Enter server.crt location : " fileLocation
	fi

	# copy the server.crt to the /etc/ssl/certs and update ca-certificates
	echo -e "Copying server.crt to /etc/ssl/certs\n"
	sudo cp "./certs/server.crt" "/etc/ssl/certs"

	# update the ca-certificates
	sudo update-ca-certificates >> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "COMPLETED [ca-certificates]"
	else
		sudo update-ca-trust >> /dev/null 2>&1
		echo "COMPLETED [ca-trust]"
		exit
	fi
}

# Check the number of cli arguments
if [ "$#" -gt 1 ] || [ "$#" -lt 1 ]; then
	commandUsage
else
	arg=$(echo $1 | tr '[:upper:]' '[:lower:]')
	if [ "$arg" != "server" ] && [ "$arg" != "client" ]; then
		echo "Wrong argument supplied"
	else
		generate_certs "$1"
	fi
fi
