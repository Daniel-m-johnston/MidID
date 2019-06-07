#! /bin/bash

function download_year {
	  class_year=${1:2}
    if [ ! -d imgs/MIDS/$1 ]; then
        mkdir imgs/MIDS/$1
    fi
    cd imgs/MIDS/$1

    for j in {0000..9999}; do
		    download_mid $class_year$j
	  done
    cd ../../..
}

function download_mid {
    url="https://usna.blackboard.com/bbcswebdav/orgs/DEPTCSERV/Midn%20Photos/20${1:0:2}/M$1.jpg"
    # curl only the header and get the status code to check if valid alpha
    response=$(curl -s -o /dev/null -I -w "%{http_code}" $url)
    if [ $response -eq 200 ]; then
        curl $url > m$1.jpg
    fi
}

year=$(date '+%Y')
month=$(date '+%m')
start_year=$year
if [[ month -ge 6 ]]; then
	start_year=$((start_year + 1))
fi

for i in {0..3}; do
	echo "Updating class of $((start_year + i))."
	download_year $((start_year + i))
done

pickle_dir=embeddings_pkl
if [ -d $pickle_dir ]
mv $pickle_dir $pickle_dir.$(date +%Y.%m.%d)
mkdir $pickle_dir

for x in imgs/MIDS/*; do
    python3 cgi-bin/embeddings.py $x
done
