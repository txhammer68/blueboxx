import QtQuick 2.9
import org.kde.plasma.core 2.1

Item {

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
        var tempArray=[];
        randomArray=[]
        var n1=0;
        for (x=0;x<5;x++) {
            n1=Math.floor(Math.random() * (max - min - x) );
            r1.includes(n1) ? n1=Math.floor(Math.random() * (max - min - x) ) : n1=n1 // check for repeats
            r1.push(n1);
        }
        tempArray=JSON.parse(JSON.stringify(movieArray))
        randomArray.push(tempArray[r1[0]]);
        randomArray.push(tempArray[r1[1]]);
        randomArray.push(tempArray[r1[2]]);
        randomArray.push(tempArray[r1[3]]);
        randomArray.push(tempArray[r1[4]]);
        r1=null;
        tempArray=null;
        n1=0;
        listView.model=randomArray.length;
        listView.delegate=movieView;
        listView.positionViewAtBeginning();
        return null;
    }

    function searchMovies (s) {
        if (typeof(movieArray) != "undefined") {
            searchArray = movieArray.filter(x => x.title.toLowerCase().includes(s.toLowerCase()));
            selectedItem="searchList"
            //(searchArray.length < 2) ? listView.anchors.leftMargin=860 : (searchArray.length < 7) ? listView.anchors.leftMargin=460 : listView.anchors.leftMargin=60
            //searchArray.length < 2 ? listView.anchors.leftMargin=860:listView.anchors.leftMargin=300
            listView.model=searchArray.length < 1 ? searchArray.length+1 : searchArray.length
            listView.anchors.leftMargin=searchArray.length < 9 ? (listView.width/2)-(searchArray.length*72) : 60
            listView.delegate=null;
            listView.delegate=movieView;
            listView.positionViewAtBeginning();
            tf.text=""
        }
        return null;
    }

    function genreSearch (s) {
        if (typeof(movieArray) != "undefined") {
            searchArray = movieArray.filter(item => item.genre.includes(s));
            selectedItem="searchList"
            //(searchArray.length < 2) ? listView.anchors.leftMargin=860 : (searchArray.length < 7) ? listView.anchors.leftMargin=460 : listView.anchors.leftMargin=60
            //searchArray.length < 2 ? listView.anchors.leftMargin=860:listView.anchors.leftMargin=300
            listView.model=searchArray.length < 1 ? searchArray.length+1 : searchArray.length
            listView.anchors.leftMargin=searchArray.length < 9 ? (listView.width/2)-(searchArray.length*72) : 60
            listView.delegate=null;
            listView.delegate=movieView;
            listView.positionViewAtBeginning();
        }
        return null;
    }

    function yearSearch (s) {
        if (typeof(movieArray) != "undefined") {
            searchArray = movieArray.filter(item =>  Math.floor(new Date(item.release_date).getFullYear()/10)*10 == s);
            selectedItem="searchList"
            //(searchArray.length < 2) ? listView.anchors.leftMargin=860 : (searchArray.length < 7) ? listView.anchors.leftMargin=460 : listView.anchors.leftMargin=60
            //searchArray.length < 2 ? listView.anchors.leftMargin=860:listView.anchors.leftMargin=300
            listView.model=searchArray.length < 1 ? searchArray.length+1 : searchArray.length
            listView.anchors.leftMargin=searchArray.length < 9 ? (listView.width/2)-(searchArray.length*72) : 60
            listView.delegate=null;
            listView.delegate=movieView;
            listView.positionViewAtBeginning();
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
            //randomArray=[]
            randomArray.push(tempArray[0])
            randomArray.push(tempArray[1])
            randomArray.push(tempArray[2])
            randomArray.push(tempArray[3])
            randomArray.push(tempArray[4])
            tempArray=null;
            selectedItem="randomList"
            listView.model=randomArray.length
            listView.anchors.leftMargin=(listView.width/2)-(randomArray.length*72)
            listView.delegate=null;
            listView.delegate=movieView;
            listView.positionViewAtBeginning();
        }
        return null;
    }
}
