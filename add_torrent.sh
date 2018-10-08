#!/bin/bash

# Add torrent files to Deluge via the JSON RPC API
# Download your favourite Linux distros in one easy script that can be driven by Siri shortcuts.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

deluge_password=$1
magnet_url=$2
move_completed_path=$3

curl  --silent --output /dev/null -c $DIR/cookies.txt --compressed -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST -d "{\"method\": \"auth.login\", \"params\": [\"${deluge_password}\"], \"id\": 1}" http://localhost:8112/json

http_code=$(curl -s -o $DIR/add_torrent_error.log -w "%{http_code}" -b $DIR/cookies.txt --compressed -i -H "Content-Type: application/json" -H "Accept: application/json" -X POST -d "{\"method\": \"core.add_torrent_magnet\", \"params\": [\"${magnet_url}\", {\"move_completed_path\": \"${move_completed_path}\" }], \"id\": 1}" http://localhost:8112/json)

if [[ $http_code -eq 200 ]]; then
	echo "Torrent added successfully!"
else
	cat "$DIR/add_torrent_error.log"
fi
