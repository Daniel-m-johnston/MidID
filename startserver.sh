#! /bin/bash
echo $$
echo $BASHPID

source venv/bin/activate
python3 -m http.server --cgi &
firefox localhost:8000 -newwindow -private

kill -- -$$

