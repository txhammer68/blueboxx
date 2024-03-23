import json
import requests
import urllib.request
import urllib
import time

# TV Series info
# 1. https://api.themoviedb.org/3/tv/66025?api_key=your key here
# first get show details, then parse each season/episode
# 2. https://api.themoviedb.org/3/tv/66025/season/1?language=en-US?api_key=your key here
# https://api.themoviedb.org/3/tv/66025?language=en-US&api_key=your key here
# https://api.themoviedb.org/3/tv/66025/season/1/episode/1?language=en-US&api_key=your key here


headers = { # change headers for your api key
    "accept": "application/json",
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3OTE1NzQ5ZWQ2OGI2OWFmMTEwMDJmNWVhMzhhYThjNiIsInN1YiI6IjYzZjFhMWJjYTI0YzUwMDBkNGUzOWNjYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.t3SAOPr_XGTTpe2d4gBMyxs9_3WDSWVXGJP9t_q7YJk"
}

listData=[]
tempData=[]
seasonData=[]
seriesData={}
tvList=[]
tempGenre=[]

url = "tv.json"
with open(url) as f:
  listData = json.load(f)   # get list of tv series

# create array of tv series ##
# https://api.themoviedb.org/3/tv/66025?api_key=
### - name, -overview, -number_of_seasons, -poster_path, -backdrop_path, - seasons[]


def getSeasonData(x,num) :
  episodeData=[]
  tempSeasonData={}
  for y in range (num) :
            getEpisodeData(x,y,tempData[0]['seasons'][y]['episode_count'],episodeData)
            tempSeasonData={'season_number':tempData[0]['seasons'][y]['season_number'],
              'air_date':tempData[0]['seasons'][y]['air_date'],
              'episode_count':tempData[0]['seasons'][y]['episode_count'],
              'name':tempData[0]['seasons'][y]['name'],
              'overview':tempData[0]['seasons'][y]['overview'],
              'poster_path':tempData[0]['seasons'][y]['poster_path'],
              'episodes':episodeData}
           # urllib.request.urlretrieve('https://image.tmdb.org/t/p/w500/'+str(tempData[0]['seasons'][y]['poster_path']), '../posters'+str(tempData[0]['seasons'][y]['poster_path']))
            seasonData.append(tempSeasonData)
            tempSeasonData={}
            episodeData=[]

def getEpisodeData(x,y,num,episodeData) :
  tempData2=[]
  tempEpisodeData={}
  for z in range(num) :
            url3 = 'https://api.themoviedb.org/3/tv/'+str(listData[x]['id'])+'/season/'+str(y+1)+'/episode/'+str(z+1)+'?language=en-US&api_key=fdedddeba3b7dec3fc1f41952ca0fb85'
            tempData2.append( requests.get(url3, headers=headers).json())
            # https://api.themoviedb.org/3/tv/66025/season/1/episode/1?api_key=your key here
            tempEpisodeData={'name':tempData2[0].get('name',"Episode: "+str(z+1)),
              'episode_number':tempData2[0].get('episode_number',"Episode: "+str(z+1)),
              'overview':tempData2[0].get('overview',tempData[0]['overview']),
              'airdate':tempData2[0].get('air_date',tempData[0]['first_air_date']),
              'runtime':tempData2[0].get('runtime',tempData[0]['episode_run_time']),
              'link':tempData[0]['name']+'-S-'+str(y+1)+'-EP-'+str(z+1)+'.mp4'}
            episodeData.append(tempEpisodeData)
            tempData2=[]
            tempEpisodeData={}
  time.sleep(5) # slow down for server responses

for x in range(len(listData)) :
   url2 = 'https://api.themoviedb.org/3/tv/'+str(listData[x]['id'])+'?language=en-US&api_key=fdedddeba3b7dec3fc1f41952ca0fb85'
   tempData.append( requests.get(url2, headers=headers).json())
   getSeasonData(x,tempData[0]['number_of_seasons'])
   for g in range(len(tempData[0]['genres'])) :
       tempGenre.append(tempData[0]['genres'][g]['name'])

   tempShowData={'id':tempData[0]['id'],
              'name':tempData[0]['name'],
              'overview':tempData[0]['overview'],
              'genres':tempGenre,
              'first_air_date':tempData[0]['first_air_date'],
              'poster_path':tempData[0]['poster_path'],
              'backdrop_path':tempData[0]['backdrop_path'],
              'seasons':seasonData}
   urllib.request.urlretrieve('https://image.tmdb.org/t/p/w1280/'+str(tempData[0]['backdrop_path']), '../backdrops'+str(tempData[0]['backdrop_path']))
   urllib.request.urlretrieve('https://image.tmdb.org/t/p/w500/'+str(tempData[0]['poster_path']), '../posters'+str(tempData[0]['poster_path']))
   seriesData[x]=tempShowData
   tempGenre=[]
   tempData=[]
   seasonData=[]
   tempShowData={}
tvList.append(seriesData[x])
f = open("tvList.json", "w+")
print(json.dumps(tvList,indent=2),end="",file=f)
f.close()
