import QtQuick 2.9

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
        interval:200
        onTriggered:newMovies();
    }

    function getData(fileUrl){
        let xhr = new XMLHttpRequest;
        xhr.open("GET", fileUrl); // set Method and File
        xhr.onreadystatechange = function () {
            if(xhr.readyState === XMLHttpRequest.DONE){ // if request_status == DONE
                if(fileUrl==url1) {
                    let response = xhr.responseText;
                    movieArray=JSON.parse(response);
                    response=null;
                }
                else {
                    let response = xhr.responseText;
                    tvArray=JSON.parse(response);
                    response=null;
                }
            }
        }
        xhr.send(); // begin the request
        return null;
    }

    function randomGen (min,max) {

        let r1=[];
        let n1=-1;
        for (x=0;x<5;x++) {
            n1=Math.floor(Math.random() * (max - min - x) );
            while (r1.includes(n1)) {
              n1=Math.floor(Math.random() * (max - min - x) )
            }
            r1.push(n1); // check for repeat
        }
        //tempArray=JSON.parse(JSON.stringify(movieArray)) // convert json to var
        randomArray.push(movieArray[r1[0]]);
        randomArray.push(movieArray[r1[1]]);
        randomArray.push(movieArray[r1[2]]);
        randomArray.push(movieArray[r1[3]]);
        randomArray.push(movieArray[r1[4]]);
        r1=null;
        //tempArray=null;
        n1=0;
        return null;
    }

    function searchMovies (s) {
        searchArray = movieArray.filter(x => x.title.toLowerCase().includes(s.toLowerCase()));
        return null;
    }

    function genreSearch (s) {
        searchArray = movieArray.filter(item => item.genre.includes(s));
        return null;
    }

    function yearSearch (s) {
        searchArray = movieArray.filter(item =>  Math.floor(new Date(item.release_date).getFullYear()/10)*10 == s);
        return null;
    }

    function newMovies () { // get 5 newest movies
        let tempArray={}
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
            scripts.randomGen(0,movieArray.length);
            tf.focus=false
            tf.text=""
            scrollView.focus=true;
            listView.anchors.leftMargin=500;
            listView.anchors.topMargin=140;
            listView.model=randomArray.length;
            listView.delegate=null;
            listView.delegate=movieView;
            listView.positionViewAtBeginning();
        return null; }

        else if (selectedItem == "movieList") {
            randomArray=[];
            searchArray=[];
            tf.focus=false;
            tf.text=""
            scrollView.focus=true;
            listView.focus=true;
            listView.anchors.leftMargin=60;
            listView.anchors.topMargin=10;
            listView.model=movieArray.length;
            listView.delegate=null;
            listView.delegate=movieView;
            listView.positionViewAtBeginning();
        return null; }

        else if (selectedItem == "searchList") {
            listView.model=searchArray.length < 1 ? searchArray.length+1 : searchArray.length
            scrollView.focus=true
            listView.anchors.leftMargin=searchArray.length < 9 ? (listView.width/2)-(listView.model*listView.cellWidth/2) : 60
            listView.anchors.topMargin=10;
            listView.delegate=null;
            listView.delegate=movieView;
            listView.positionViewAtBeginning();
            tf.focus=false;
        return null; }

        else if (selectedItem == "tvList") {
            randomArray=[];
            searchArray=[];
            tf.focus=false;
            tf.text=""
            scrollView.focus=true;
            listView.anchors.leftMargin=60;
            listView.anchors.topMargin=10;
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
        return "backdrops"+randomArray[currentItem].backdrop_path
      else if (selectedItem=="movieList")
        return "backdrops"+movieArray[currentItem].backdrop_path
      else if (selectedItem=="searchList")
        if (searchArray.length > 0)
           return "backdrops"+searchArray[currentItem].backdrop_path
     else return "bk2.png"
    }

    if (sel == "title") {
      if (selectedItem=="randomList")
        return randomArray[currentItem].title
      else if (selectedItem=="movieList")
        return movieArray[currentItem].title
      else if (selectedItem=="searchList") {
        if (searchArray.length > 0)
          return searchArray[currentItem].title
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
  }
}
