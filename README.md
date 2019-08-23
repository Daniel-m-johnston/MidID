<h1>MidID</h1>
<h3>Live Facial Recognition of Midshipmen</h3>

<h4>Install</h4>
Requires Python 3, Pip, and VirtualEnv
Clone the repository, then run `INSTALL.sh` 
This will set up a new Python virtual environment inside the repository, and pip install all of the required libraries. Once the virtual environment is ready, the install script will run `update.sh`, which will download the 4 class years of Mids photos that should be available. The script assumes that the newest class' photos will be uploaded by September, so it will not attempt to download them before then. (This can be changed by editing the `update.sh` script; change the `AC_YEAR_START_MONTH` variable to the desired month.

Once the photos are downloaded, it will then process them, creating the vector embeddings which are used to recognize faces. These are pickled and stored in the `embeddings_pkl` directory. 

When a new Academic Year begins, run `update.sh` to download the latest MIDS photos.

`update.sh` will track its progress in a hidden file, `.update_progress`
If `update.sh` is interrupted, it will attempt to resume from where it was stopped. If this behavior isn't desired, delete `.update_progess` and it will update from the beginning.
