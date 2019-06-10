#! /bin/bash

progress_file='.update_progress'

function progress_update {
    echo "$start_year $index $1"
}

function download_year {
	  class_year=${1:2}

    # prevent leading 0s from causing number to be interpreted as octal
    start_alpha=$2
    start_alpha=$((10#$start_alpha))

    if [ ! -d imgs/MIDS/$1 ]; then
        mkdir imgs/MIDS/$1
    fi
    cd imgs/MIDS/$1

    for ((j=start_alpha; j < 9999; j++)); do
        last_four=$(printf "%04d" $j)
		    download_mid $class_year$last_four
        progress_update $last_four > ../../../$progress_file
	  done
    cd ../../..
}

function download_mid {
    url="https://usna.blackboard.com/bbcswebdav/orgs/DEPTCSERV/Midn%20Photos/20${1:0:2}/M$1.jpg"
    # curl only the header and get the status code to check if valid alpha
    response=$(curl -s -o /dev/null -I -w "%{http_code}" $url)
    # if good response, download the image
    if [ $response -eq 200 ]; then
        curl $url > m$1.jpg
    fi
}


#-------------------------------------MAIN-------------------------------------#

start_year=""
index=0
alpha=0000

# need to restart in the middle if script closed unexpectedly
if [ -f $progress_file ]; then
    progress=$(tail -n1 $progress_file)
    progress=($progress)
    start_year=${progress[0]}
    index=${progress[1]}
    alpha=${progress[2]}
    echo "Resuming from ${start_year:2}$alpha"

# otherwise, figure out the date to know what classes can be updated
else
    year=$(date '+%Y')
    month=$(date '+%m')
    start_year=$year

    # If past May, AY is next calendar year
    if [[ month -ge 6 ]]; then
	      start_year=$((start_year + 1))
    fi
fi

# Download each of the next 4 class years
for ((i=index; i < 3; i++)); do
	echo "Updating class of $((start_year + i))."
  index=$i # update index for progress tracking
	download_year $((start_year + i)) $alpha
  alpha=0000 # reset alpha in case we resumed
done

# Now update the embeddings
pickle_dir="embeddings_pkl"

# backup the old directory
if [ -d $pickle_dir ]; then
   cp -r $pickle_dir $pickle_dir.$(date +%Y.%m.%d)
fi

source venv/bin/activate

for x in imgs/MIDS/*; do
    python3 cgi-bin/embeddings.py $x
done