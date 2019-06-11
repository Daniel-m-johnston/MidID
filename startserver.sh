#! /bin/bash

source venv/bin/activate
python3 -m http.server --cgi 2> /dev/null &
firefox localhost:8000 -newwindow -private 2> /dev/null

read -n 1 -p 'Press any key to kill server... '
echo ''
kill -- -$$

