import QtQuick 2.9
// scripts for blueboxx app
Item {

    Component.onCompleted: {
        getData(url1);
        getData(url2);
        init.start();
    }

    Timer {
        id:init
        running:false
        repeat:false
        interval:250
        onTriggered:{
          movieCnt();
          newMovies();
          initRandom();
        }
    }

    function getData(fileUrl){
        let xhr = new XMLHttpRequest;
        xhr.open("GET", fileUrl); // set Method and File
        xhr.onreadystatechange = function () {
            if(xhr.readyState === XMLHttpRequest.DONE){ // if request_status == DONE
                if(fileUrl==url1) {
                    movieArray=JSON.parse(xhr.responseText);
                    //movieArrayChanged();
                    xhr=null;
                }
                else {
                    tvArray=JSON.parse(xhr.responseText);
                    //tvArrayChanged();
                    xhr=null;
                }
            }
        }
        xhr.send(); // begin the request
        return null;
    }

    function movieCnt () {
         let t1=0
         for (x=0;x<movieArray.length;x++) {
           if (movieArray[x].hasOwnProperty("collection")) {
             collectionItems+=1
             t1+=movieArray[x].parts.length
           }
        }
      collectionCount=t1;
      //movieCount=movieArray.length+collectionCount-collectionItems
      return null;
    }

    function shuffle(o) {
          for(var j, x, i = o.length; i; j = parseInt(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
          return o;
      }

    function initRandom() {
       usedArray=[];
       idx=0;
       for (x=0;x<movieArray.length;x++){
        usedArray.push(x)
       }
      usedArray=shuffle(usedArray);
      usedArray=shuffle(usedArray);
      return null;
    }

    function randomGen() {
      //randomArray=[];
      for (x=0;x<5;x++) {
        if(idx==usedArray.length){
           initRandom();
        }
        randomArray.push(movieArray[usedArray[idx]]);
        idx++
      }
      return null;
    }

    function searchMovies (s) {
        let t1=[]
        let t2=[]
        searchArray=movieArray.filter(item => item.title.toLowerCase().includes(s.toLowerCase()))
        for (x=0;x<movieArray.length;x++) {
          if (movieArray[x].hasOwnProperty("collection") ) {
            for (y=0;y<movieArray[x].parts.length;y++) {
              if (movieArray[x].parts[y].title.toLowerCase().includes(s.toLowerCase() ))
                t1.push(movieArray[x].parts[y])
            }
          }
        }
        t2=t2.concat(searchArray);
        t2=t2.concat(t1);
        searchArray=t2;
        searchArray.sort((a, b) => (a.title > b.title ? 1 : -1));
        t1=null;
        t2=null;
       // searchArrayChanged();
        return null;
    }

    function genreSearch (s) {
        searchArray = movieArray.filter(item => item.genre.includes(s));
        //searchArrayChanged();
        return null;
    }

    function yearSearch (s) {
        var t1=[]
        searchArray = movieArray.filter(item =>  Math.floor(new Date(item.release_date).getFullYear()/10)*10 == s);
        //t1 = movieArray.filter(item => item.parts.filter(x => Math.floor(new Date(x.release_date).getFullYear()/10)*10 == s))
        //t1 = movieArray.filter(x => x.hasOwnProperty('parts')  && Math.floor(new Date(x.release_date).getFullYear()/10)*10 == s)
        //searchArray=t1
        //searchArrayChanged();
        return null;
    }

    function newMovies () { // get 5 newest movies
        let tempArray=[]
        tempArray=JSON.parse(JSON.stringify(movieArray))
        tempArray=tempArray.sort((a, b) => {
              return new Date(b.release_date) - new Date(a.release_date); // descending
          })
        randomArray.push(tempArray[0])
        randomArray.push(tempArray[1])
        randomArray.push(tempArray[2])
        randomArray.push(tempArray[3])
        randomArray.push(tempArray[4])
        tempArray=null;
       // randomArrayChanged();
        selectedItem="randomList"
        listView.model=randomArray.length
        listView.anchors.leftMargin=500;
        listView.anchors.topMargin=140;
        listView.delegate=null;
        listView.delegate=movieView;
        listView.positionViewAtBeginning();
        return null;
    }

    function selectedViewChanged () {
        listView.anchors.leftMargin=0;

        if (selectedItem == "randomList") {
            randomArray=[];
            searchArray=[];
            collectionArray=[];
           // randomArrayChanged();
            //searchArrayChanged();
            //collectionArrayChanged();
            randomGen();
            movieCount=movieArray.length+collectionCount-collectionItems
            tf.placeholderText="Movie Search...\t "+"                   ("+movieCount+")".replace(" ",'&#32')
            tf.focus=false
            tf.text=""
            listView.anchors.leftMargin=500;
            listView.anchors.topMargin=140;
            listView.model=randomArray.length;
            listView.delegate=null;
            listView.delegate=movieView;
            listView.positionViewAtBeginning();
            listView.focus=true;
        return null; }

        else if (selectedItem == "movieList") {
            randomArray=[];
            searchArray=[];
            collectionArray=[];
            movieCount=movieArray.length+collectionCount-collectionItems
            tf.placeholderText="Movie Search...\t "+"                   ("+movieCount+")".replace(" ",'&#32')
            tf.focus=false;
            tf.text=""
            //randomArrayChanged();
            //searchArrayChanged();
            //collectionArrayChanged();
            listView.focus=true;
            listView.anchors.leftMargin=65;
            listView.anchors.topMargin=30;
            listView.model=movieArray.length;
            listView.delegate=null;
            listView.delegate=movieView;
            listView.positionViewAtBeginning();
        return null; }

        else if (selectedItem == "searchList") {
            randomArray=[];
            collectionArray=[];
            //randomArrayChanged();
            //collectionArrayChanged();
            movieCount=searchArray.length > 0 ? searchArray.length:0
            tf.focus=false;
            tf.placeholderText="Movie Search...\t "+"                   ("+movieCount+")".replace(" ",'&#32')
            listView.model=searchArray.length < 1 ? searchArray.length+1 : searchArray.length
            listView.anchors.leftMargin=searchArray.length < 9 ? (listView.width/2)-(listView.model*listView.cellWidth/2) : 65
            listView.anchors.topMargin=30;
            listView.delegate=null;
            listView.delegate=movieView;
            listView.positionViewAtBeginning();
        return null; }

        else if (selectedItem == "tvList") {
            randomArray=[];
            searchArray=[];
            collectionArray=[];
            tf.focus=false;
            tf.text=""
            //randomArrayChanged();
            //searchArrayChanged();
            //collectionArrayChanged();
            movieCount=movieArray.length+collectionCount-collectionItems
            tf.placeholderText="Movie Search...\t "+"                   ("+movieCount+")".replace(" ",'&#32')
            listView.anchors.leftMargin=65;
            listView.anchors.topMargin=30;
            listView.model=tvArray.length;
            listView.delegate=null;
            listView.delegate=movieView;
            listView.positionViewAtBeginning();
        return null; }
     else return null;
    }

   function selectSource (sel) {
     if (sel == "backdrop") {
       if (selectedItem=="randomList")
        return "./backdrops"+randomArray[currentItem].backdrop_path
      else if (selectedItem=="movieList")
        return "./backdrops"+movieArray[currentItem].backdrop_path
      else if (selectedItem=="searchList")
        if (searchArray.length > 0)
           return "./backdrops"+searchArray[currentItem].backdrop_path
     else return "bk2.png"
    }

    if (sel == "poster") {
       if (selectedItem=="randomList")
        return "./posters"+randomArray[currentItem].poster_path
      else if (selectedItem=="movieList")
        return "./posters"+movieArray[currentItem].poster_path
      else if (selectedItem=="searchList")
        if (searchArray.length > 0)
           return "./posters"+searchArray[currentItem].poster_path
      else if (selectedItem=="tvList")
        return "./posters/"+tvArray[currentItem].poster_path
     else return "./posters/movie-poster-credits-178.jpg"
    }

    if (sel == "title") {
      if (selectedItem=="randomList")
        return randomArray[currentItem].title
      else if (selectedItem=="movieList")
        return movieArray[currentItem].title
      else if (selectedItem=="searchList") {
        if (searchArray.length > 0)
          return searchArray[currentItem].title
      else if (selectedItem=="tvList")
        return tvArray[currentItem].title
        else return "Nothing Found" }
    }

    if (sel == "media") {
      if (selectedItem=="randomList")
        return Qt.openUrlExternally(movieDir+randomArray[currentItem].link)
      else if (selectedItem=="movieList")
        return Qt.openUrlExternally(movieDir+movieArray[currentItem].link)
      else if (selectedItem=="searchList") {
         if (searchArray.length > 0)
           return Qt.openUrlExternally(movieDir+searchArray[currentItem].link)
      else if (selectedItem=="tvList")
        return "./posters/"+tvArray[currentItem].link
         else return Qt.openUrlExternally("https://www.imdb.com/") }
    }

    if (sel == "summary") {
      if (selectedItem=="randomList")
        return randomArray[currentItem].overview;
      else if (selectedItem=="movieList")
        return movieArray[currentItem].overview;
      else if (selectedItem=="searchList") {
         if (searchArray.length > 0)
          return searchArray[currentItem].overview
        else return "No Results" }
    }

    if (sel == "genre") {
      if (selectedItem=="randomList")
        return "🎭 "+randomArray[currentItem].genre.slice(0, -1).replace(/,/g, ', ')
      else if (selectedItem=="movieList")
        return "🎭 "+movieArray[currentItem].genre.slice(0, -1).replace(/,/g, ', ')
      else if (selectedItem==="searchList") {
        if (searchArray.length > 0)
          return "🎭 "+searchArray[currentItem].genre.slice(0, -1).replace(/,/g, ', ')
        else return "🎭  -" }
    }

    if (sel == "runtime") {
      if (selectedItem=="randomList")
        return "⏳ "+randomArray[currentItem].runtime
      else if (selectedItem=="movieList")
        return "⏳ "+movieArray[currentItem].runtime
      else if (selectedItem==="searchList") {
        if (searchArray.length > 0)
          return "⏳ "+searchArray[currentItem].runtime
        else return "⏳  -" }
    }

    if (sel == "date") {
      if (selectedItem=="randomList")
        return "🗓️  "+new Date(randomArray[currentItem].release_date).getFullYear()
      else if(selectedItem=="movieList")
        return "🗓️  "+new Date(movieArray[currentItem].release_date).getFullYear()
      else if (selectedItem=="searchList") {
        if (searchArray.length > 0)
            return "🗓️  "+new Date(searchArray[currentItem].release_date).getFullYear()
        else return "🗓️  -" }
    }

    if (sel == "trailer") {
      if (selectedItem=="randomList")
        return trailerDir+randomArray[currentItem].trailer
    else if (selectedItem=="movieList")
        return trailerDir+movieArray[currentItem].trailer
    else if (selectedItem=="searchList") {
      if (searchArray.length > 0)
        return trailerDir+searchArray[currentItem].trailer
      else return null }
    }

    if (sel == "rating") {
      if (selectedItem=="randomList")
        return "⭐  "+parseFloat(randomArray[currentItem].rating).toFixed(1).toString()
      else if (selectedItem=="movieList")
        return "⭐  "+parseFloat(movieArray[currentItem].rating).toFixed(1).toString()
      else if (selectedItem=="searchList") {
        if (searchArray.length > 0)
         return "⭐  "+parseFloat(searchArray[currentItem].rating).toFixed(1).toString()
      else return "⭐  -" }
    }
     if (sel == "id") {
      if (selectedItem=="randomList")
        return randomArray[currentItem].id
      else if (selectedItem=="movieList")
        return movieArray[currentItem].id
      else if (selectedItem==="searchList") {
        if (searchArray.length > 0)
          return searchArray[currentItem].id
        else return "12" }
    }
  }

  function tvGenre() {
    let temp=""
    for (x=0;x<tvArray[currentItem].genres.length;x++) {
      temp=temp.concat(tvArray[currentItem].genres[x],",")
    }
    temp=temp.slice(0, -1).replace(/,/g, ', ')
    tvGenres=temp;
    return null;
  }
}
