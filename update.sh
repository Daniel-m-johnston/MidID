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

# need to restart in the middle if script closed unexpectedly
if [ -f .update_progress ]; then
    #figure out how to start up here
fi
year=$(date '+%Y')
month=$(date '+%m')
start_year=$year

# If past May, AY is next calendar year
if [[ month -ge 6 ]]; then
	start_year=$((start_year + 1))
fi

# Download each of the next 4 class years
for i in {0..3}; do
	echo "Updating class of $((start_year + i))."
	download_year $((start_year + i))
done

# Now update the embeddings
pickle_dir=embeddings_pkl
# backup the old directory
if [ -d $pickle_dir ]
   cp $pickle_dir $pickle_dir.$(date +%Y.%m.%d)
fi

for x in imgs/MIDS/*; do
    python3 cgi-bin/embeddings.py $x
done
