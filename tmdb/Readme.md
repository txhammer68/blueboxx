### TMDB API Info

### Download movie data
1. tmdb.py will download master movie/tv list from tmdb api to tmdb.json, tv.json
2. movieInfo will parse tmdb.json remove unecessary keys, add genres, trailer info and media link info and save to movies.json

* getMovieInfo.py will display json for particiluar movie id to add later to movies.json, manual process
* posters.py will download all art work for shows
* trailers.py will find links to trailers for all shows, paste results into trailers.txt
* trailers.sh and trailers.txt will download all trailers using yt-dlp

### Get TV Series Data
* getTVSeriesInfo.py
    * downloads tv show info seasons, episodes, art work, creates tvList.json
### Trailers
https://api.themoviedb.org/3/movie/11548/videos?api_key=fde5ddeba3c7dec3jc1f51852ca0fb95
get youtube key and use yt-dlp to download a matching trailer key for show
yt-dlp --format=mp4 -o "Dune: Part Two - Trailer.mp4" "https://www.youtube.com/watch?v="+trailerKey

For example:
Youtube: https://www.youtube.com/watch?v=ASWO43n3QkQ
Vimeo: https://vimeo.com/282875052

### TMDB Notes
Movie Data json structure <br>
https://api.themoviedb.org/3/movie/209403?api_key= <br>

```
- title
- overview
- release_date
- rating
- runtime
- genres[]
- backdrop_path
- poster_path
- link to media (Predifned link to video is media title.mp4)
```
TV Series data json structure <br>
https://api.themoviedb.org/3/tv/1425?language=en-US&api_key= <br>

```
- name
- overview
- first_air_date
- runtime
- rating
- genres[]
- backdrop_path
- poster_path
- seasons []
  - episodes []
    - link to media (Predefined link to video is Series Title/Series Title-S-1-EP-1.mp4)
    - link to media (Series Title/Series Title-S-1-EP-2.mp4)
```

backdrop_path	"/b7HsWYjyrVkDPkAFFAGZ76iainK.jpg"
    wget https://image.tmdb.org/t/p/w1280/+backdrop_path

poster_path
    wget https://image.tmdb.org/t/p/w500/+poster_path


