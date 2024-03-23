import json
import requests
import urllib.request

genre=''
movieID='802219'  # get movie info from tmdb, add movie details to master movies.json list
# for adding to existing json list movies.json
headers = {
    "accept": "application/json",
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3OTE1MzQ5ZWQ2OGI2OWFmMTEwMDJmNWVhMzhhYThjNiIsInN1YiI6IjYzZjFhMWJjYTI0YzUwMDBkNGUzOWNjYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.t3SAOPr_XGTTpe2d4gBMyxs9_3WDSVVXBJP9t_q7YJk"
}
url2 = 'https://api.themoviedb.org/3/movie/'+movieID+'?api_key=fde5ddeba3b7dec3fc1f51852ca0fb95'
response = requests.get(url2, headers=headers).json()

for z in range(len(response.get('genres',0))):
      genre+=str(response['genres'][z]['name'])+','

movieData = {
        "title": response['title'],
        "overview": response['overview'],
        "rating":round(response['vote_average'],1),
        "poster_path": response['poster_path'],
        "backdrop_path": response['backdrop_path'],
        "runtime": str("%2d:%02d"%(divmod(response['runtime'],60))).replace(" ",""),
        "release_date": response['release_date'],
        "genre": genre,
        "trailer":response["title"]+" - Trailer.mp4",
        "link":response["title"]+".mp4"
    }
urllib.request.urlretrieve(' https://image.tmdb.org/t/p/w1280/'+response['backdrop_path'], '../backdrops'+response['backdrop_path'])
urllib.request.urlretrieve(' https://image.tmdb.org/t/p/w500/'+response['poster_path'], '../posters'+response['poster_path'])
print(json.dumps(movieData,indent=2),end="")


### Trailer download
## yt-dlp --format=mp4 -o "Bob Marley: One Love - Trailer.mp4" https://www.youtube.com/watch?v=ajw425Kuvtw

# https://api.themoviedb.org/3/movie/11252?api_key=fde5ddeba3b7dec3fc1f51852ca0fb95

