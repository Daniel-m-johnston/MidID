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
}

function download_mid {
	 $1
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

