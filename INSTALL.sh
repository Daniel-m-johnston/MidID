#!/bin/bash

# Install script to setup MidID to run locally

# create a virtual environment to run in
echo 'Creating virtual environment'
python3 -m virtual-env venv
source venv/bin/activate

# install dependencies
echo 'Installing dependencies'
while read line; do
	pip3 install $line
done < requirements.txt

# run update script to get latest images
echo 'Downloading MIDS images and making embeddings. This will take some time.'
./update.sh
