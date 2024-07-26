## BlueBoxx Media Manager App

* A DIY media manager project
* Simple python/qml app for organizing movies/tv shows
* Using json arrays for media lookup
* Lighweight and Fast
* Designed for 1920x1080 screens

* This is a framework for your existing media
* Create an account on https://www.themoviedb.org/
* On TMDB create a media list one for movies, another for tv series of all the shows you have...
    * Also not a watchlist, but a unique list for each type of media
    * Make note of the lists ID's

* Once finished with creating media lists
    * API Docs https://developer.themoviedb.org/docs/getting-started
    * Get a feel for the API, with your media titles
    * Edit tmdb.py enter api credentials and lists id's
    * Run tmdb.py to download media info to movies.json, tv.json
        * Could be long download time, depending on amount of media you have...test first
    * Includes title, overview, media poster, backdrop image, trailers.

### Requirements
* Linux, preferrably KDE Plasma distro
* Python 3, python3-pyqt5, python3-pyqt5.quick, PyQt5.QtCore, PyQt5.QtGui, PyQt5.QtQml, PyQt5.QtWidgets
* mpv, vlc or other media player
* Should work on Windows,Mac OS as python is cross platform, not tested.

### Usage
* Launch app with python3 blueboxx.py
* Now Showing Button displays 5 random movies
* Movies Button displays all movies with search ability, clicking movie poster will display additonal media info
* TV Button shows all TV series, clicking tv series poster will display additional tv series info
* Search by movie title
* Advanced Search by movie genre or movie decade
* ESC key will quit the app and any other popup dialogs

### Notes
* Change locations for your json arrays, movie, tv and trailer locations in
    * BlueBoxx.qml
* Within json array, media links are predefined as "media title - Trailer.mp4", "media title.mp4", change for your needs
* Why Blueboxx, cause Redbox provided most of the titles...
* https://github.com/txhammer68/blueboxx
* Based on Qt5, but should work with Qt6

<img alt="preview" src="preview.gif" width="1400">

