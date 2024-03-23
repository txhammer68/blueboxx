import json
from datetime import datetime

### Create new json array select keys from TMDB info ***************************

url = "movies.json"

movieArray=[]
data={}
genre=''

with open(url) as f:
  data = json.load(f)
for y in range(len(data)):
  ## d=datetime.strptime(data[y].get("release_date"),"%Y-%m-%d")
  rt=str("%2d:%02d"%(divmod(data[y]['runtime'],60))).replace(" ","")
  for z in range(len(data[y].get('genre_ids',0))):
      if(data[y]["genre_ids"][z]==28) :
        genre+=("Action,")
      elif(data[y]["genre_ids"][z]==12) :
        genre+=("Adventure,")
      elif(data[y]["genre_ids"][z]==16) :
        genre+=("Animation,")
      elif(data[y]["genre_ids"][z]==35) :
        genre+=("Comedy,")
      elif(data[y]["genre_ids"][z]==80) :
        genre+=("Crime,")
      elif(data[y]["genre_ids"][z]==99) :
        genre+=("Documentary,")
      elif(data[y]["genre_ids"][z]==18) :
        genre+=("Drama,")
      elif(data[y]["genre_ids"][z]==10751) :
        genre+=("Family,")
      elif(data[y]["genre_ids"][z]==14) :
        genre+=("Fantasy,")
      elif(data[y]["genre_ids"][z]==36) :
        genre+=("History,")
      elif(data[y]["genre_ids"][z]==27) :
        genre+=("Horror,")
      elif(data[y]["genre_ids"][z]==10402) :
        genre+=("Music,")
      elif(data[y]["genre_ids"][z]==9648) :
        genre+=("Mystery,")
      elif(data[y]["genre_ids"][z]==10749) :
        genre+=("Romance,")
      elif(data[y]["genre_ids"][z]==878) :
        genre+=("Science Fiction,")
      elif(data[y]["genre_ids"][z]==10770) :
        genre+=("TV Movie,")
      elif(data[y]["genre_ids"][z]==53) :
        genre+=("Thriller,")
      elif(data[y]["genre_ids"][z]==10752) :
        genre+=("War,")
      elif(data[y]["genre_ids"][z]==37) :
        genre+=("Western,")
  movieData = {
        "title": data[y].get("title"),
        "overview": data[y].get("overview"),
        "rating":round(data[y].get("vote_average"),1),
        "poster_path": data[y].get("poster_path"),
        "backdrop_path": data[y].get("backdrop_path"),
        "runtime": rt,
        "release_date": data[y].get("release_date"),
        "genre": genre,
        "trailer":data[y].get("title")+" - Trailer.mp4",
        "link":data[y].get("title")+".mp4"
    }
  movieArray.append(movieData)
  genre=''
  movieData={}

f = open("movieList.json", "w+")
print(json.dumps(movieArray,indent=2),end="",file=f)
f.close()
