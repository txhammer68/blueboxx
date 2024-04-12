import json
import requests
import urllib.request
import time

# download media artwork
# could take a while depending on size of list

url = "movies.json"
url2 = "tv.json"

def getMoviePosters():
  with open(url) as f:
  data = json.load(f)
  for y in range(len(data)):
     if (y % 20 == 0) : ## slow down for server overload
     time.sleep(5)
     urllib.request.urlretrieve('https://image.tmdb.org/t/p/w1280/'+str(data[y]['backdrop_path']), '../backdrops'+str(data[y]['backdrop_path']))
     urllib.request.urlretrieve('https://image.tmdb.org/t/p/w500/'+str(data[y]['poster_path']), '../posters'+str(data[y]['poster_path']))

def getTVPosters():
  with open(url2) as f:
  data = json.load(f)
  for y in range(len(data)):
     if (y % 20 == 0) :
     time.sleep(5)
     urllib.request.urlretrieve('https://image.tmdb.org/t/p/w1280/'+str(data[y]['backdrop_path']), '../backdrops'+str(data[y]['backdrop_path']))
     urllib.request.urlretrieve('https://image.tmdb.org/t/p/w500/'+str(data[y]['poster_path']), '../posters'+str(data[y]['poster_path']))
getMoviePosters ()
getTVPosters ()
