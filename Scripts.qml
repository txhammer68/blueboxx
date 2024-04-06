import QtQuick 2.9
import org.kde.plasma.core 2.1

Item {

    Component.onCompleted: {
        getData(url1);
        getData(url2);
        init.start();
        listView.focus=true
        scrollView.focus=true;
        //selectedViewChanged ();
    }

    Timer {
        id:init
        running:false
        repeat:false
        interval:200
        onTriggered:newMovies();
    }

    function getData(fileUrl){
        var xhr = new XMLHttpRequest;
        xhr.open("GET", fileUrl); // set Method and File
        xhr.onreadystatechange = function () {
            if(xhr.readyState === XMLHttpRequest.DONE){ // if request_status == DONE
                if(fileUrl==url1) {
                    var response = xhr.responseText;
                    movieArray=JSON.parse(response);
                    response=null;
                }
                else {
                    var response = xhr.responseText;
                    tvArray=JSON.parse(response);
                    response=null;
                }
            }
        }
        xhr.send(); // begin the request
        return null;
    }

    function randomGen (min,max) {
        var r1=[];
        var n1=0;
        for (x=0;x<5;x++) {
            n1=Math.floor(Math.random() * (max - min - x) );
            r1.includes(n1) ? n1=Math.floor(Math.random() * (max - min - x) ) : n1=n1 // check for repeats
            r1.push(n1);
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
        if (typeof(movieArray) != "undefined") {
            searchArray = movieArray.filter(x => x.title.toLowerCase().includes(s.toLowerCase()));
        }
        return null;
    }

    function genreSearch (s) {
        if (typeof(movieArray) != "undefined") {
            searchArray = movieArray.filter(item => item.genre.includes(s));
        }
        return null;
    }

    function yearSearch (s) {
        if (typeof(movieArray) != "undefined") {
            searchArray = movieArray.filter(item =>  Math.floor(new Date(item.release_date).getFullYear()/10)*10 == s);
        }
        return null;
    }

    function newMovies () { // get 5 newest movies
        if (typeof(movieArray) != "undefined") {
            var tempArray={}
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
            //listView.anchors.leftMargin=searchArray.length < 9 ? (listView.width/2)-(searchArray.length*72) : 60
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
}
