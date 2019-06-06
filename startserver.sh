#! /bin/bash
echo $$
echo $BASHPID
python3 -m http.server --cgi &
firefox localhost:8000 

kill -- -$$

