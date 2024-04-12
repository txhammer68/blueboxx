### TMDB API Info

### Get movie data
1. tmdb.py will download master movie list from tmdb api to tmdb.json
2. movieInfo will parse tmdb.json remove unecessary keys, add genres, trailer info and media link info and save to movies.json

* addmovieInfo.py will add new movie to movies.json
    downloads movie art work, trailer, movie info,and inserts data into movies.json
* getMovieInfo.py will display json for particiluar movie id to add later to movies.json

### Get TV Series Data
* getTVSeriesInfo.py
    * downloads tv show info seasons, episodes, art work,inserts data into tvList.json

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
    - link to media (Predefined link to video is Series Title-S-1-EP-1.mp4)
    - link to media (Series Title-S-1-EP-2.mp4)
```

backdrop_path	"/b7HsWYjyrVkDPkAFFAGZ76iainK.jpg"
    wget https://image.tmdb.org/t/p/w1280/+backdrop_path

poster_path
    wget https://image.tmdb.org/t/p/w500/+poster_path

Trailers
https://api.themoviedb.org/3/movie/11548/videos?api_key=fde5ddeba3b7dec3fc1f51852ca0fb95
use key to append url

For example:
Youtube: https://www.youtube.com/watch?v=ASWO43n3QkQ
Vimeo: https://vimeo.com/282875052


