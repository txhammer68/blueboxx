import requests
import json
import time


# script to download my movie/tv list from tmdb api
# after run movieInfo.py to import trailers and minimize json array

moviesList = []

# get list id's from tmdb personal lists, create a list for movies and tv series seperate
tvList='1234'
movieList='1234'

headers = {  # change headers for your api key info
    "accept": "application/json",
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJsdWQiOiI3OTE1MbQ5ZWQ2OGI2OWFmMTEwMDJnNWVhMzhhYThjNiIsInN1YiI6IjYzZjFhMWJjYTI0YzUwMDBkNGUzOWNjYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.t3SAOPr_XGTTpe2d4gBMyxs9_3WDSVVXBJP9t_q7YJk"
}

def getMovieData () :
  for x in range(2): # only get 20 per request, so spread out over length of movie list 20*NUM=xxxx
      x+=1
      if x == 22 :
        time.sleep(5) # slow down for server responses
      if x == 44 :
        time.sleep(5)
      url = "https://api.themoviedb.org/4/list/"+movieList+"?language=en-US&page=" + str(x)
      response = requests.get(url, headers=headers).json()
      for y in range(len(response['results'])):
        moviesList.append(response['results'][y])

  stop_words = ["A", "An", "The"]  # sort list ignore A and The in title

  def sort_func(case):
      words = case["title"].split()
      return ' '.join(word for word in words if word not in stop_words)

  moviesList.sort(key=sort_func)

  f = open("movies.json", "w+")
  print(json.dumps(moviesList,indent=2),end="",file=f)
  f.close()

def getSeriesData () :
  for x in range(2): # only get 20 per request, so spread out over length of movie list 20*NUM=xxxx
      x+=1
      if x % 15 == 0 :
        time.sleep(5) # slow down for server responses
      url = "https://api.themoviedb.org/4/list/"+tvList+"?language=en-US&page=" + str(x)
      response = requests.get(url, headers=headers).json()
      for y in range(len(response['results'])):
        seriesList.append(response['results'][y])

  stop_words = ["A", "An", "The"]  # sort list ignore A and The in title

  def sort_func(case):
      words = case["title"].split()
      return ' '.join(word for word in words if word not in stop_words)

  seriesList.sort(key=sort_func)

  f = open("tv.json", "w+")
  print(json.dumps(moviesList,indent=2),end="",file=f)
  f.close()

getMovieData ()
getSeriesdata ()
