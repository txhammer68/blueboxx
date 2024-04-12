import json
import requests
import urllib.request
import time


# get trailers based on movie id, not reliable, as some have no trailer *****
# trailers from youtube, prints formated youtube link, to later download with yt-dlp
# len(data) should match len(youTubeLink), but does not
# print links with no youtube link or trailer key missing ??
# careful, over 1000 requests made, pare down to test it

url = "tmdb.json"
headers = {
    "accept": "application/json",
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3OTE1MzQ5ZWQ2OGI2OWFmMTEmMDJmNWVhMzhbYThkN1IsInN1YiI6IjYzZjFhMWJjYTI0YzUwMDBkNGUzOWNjYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.t3SAOPr_XGTTpe2d4gBMyxs9_3WDSVVXBJP9t_q7YJk"
}

## yt-dlp --format=mp4 -o "/trailers/%(title)s.%(ext)s" https://www.youtube.com/watch?v=W34hF0rsj94

youTubeLink=[]

with open(url) as f:
  data = json.load(f)

for y in range(len(data)):
    trailerLink=str('http://api.themoviedb.org/3/movie/')+str(data[y]['id'])+str('/videos?api_key=7915369ed65b69af11002f5ea38aa8c6')
    # print(trailerLink)
    response = requests.get(trailerLink, headers=headers).json()

    for z in range(len(response['results'])):
          if (response['results'][z]['type'] == 'Trailer') :
             youTubeKey=str(response['results'][z]['key'])
             if y % 20 == 0 :
                time.sleep(5)
             # youTubeLink.append('https://www.youtube.com/watch?v='+str(youTubeKey)
             print('https://www.youtube.com/watch?v='+str(youTubeKey))
             z=(len(response['results'])+1)
             break

### Trailer download
## yt-dlp --format=mp4 -o "Bob Marley: One Love - Trailer.mp4" https://www.youtube.com/watch?v=ajw425Kuvtw
