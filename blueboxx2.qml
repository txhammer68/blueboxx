import QtQuick 2.9
import QtQuick.Layouts 1.5
import QtQuick.Controls 2.5 as QC25
import QtQuick.Controls 1.5 as QC15
import org.kde.plasma.components 2.0
import org.kde.plasma.core 2.1


// *** Streaming movie app
// *** txhammer
// *** 11/2023
// *** json arrays for movie/tv shows

Image {
    id:root
    anchors.fill:rootMain
    source:"bk2.png"
    //opacity:1
    //antialiasing:true
    property var movieArray:{}
    property var tvArray:{}
    property var randomArray:[]
    property var searchArray:[]
    property var usedArray:[]
    property var selectedItem:randomArray
    property string url1:"movies.json"
    property string url2:"tv.json"
    property int key:0
    property string selectedMovie:""
    property string selectedMoviePlaylist:""
    property string selectedMovieSubtitle:""
    property string mpvCMD:"mpv --force-media-title="+"\x22"+selectedMovie+"\x22"+" "+selectedMoviePlaylist+" --sub-file="+"\x22"+selectedMovieSubtitle+"\x22"

    anchors.margins:0

    Component.onCompleted: {
        getData(url1);
        getData(url2);
        init.start();
    }

    Text {
        text:usedArray.length
        color:"white"
        font.pointSize:14
        anchors.top:root.top
        anchors.right:root.right
        anchors.margins:40
    }

     DataSource {
            id: executable
            engine: "executable"
            connectedSources: []
            property var callbacks: ({})
            onNewData: {
                var stdout = data["stdout"]

                if (callbacks[sourceName] !== undefined) {
                    callbacks[sourceName](stdout);
                }

                exited(sourceName, stdout)
                disconnectSource(sourceName) // exec finished
            }

            function exec(cmd, onNewDataCallback) {
                if (onNewDataCallback !== undefined){
                    callbacks[cmd] = onNewDataCallback
                }
                connectSource(cmd)
            }
            signal exited(string sourceName, string stdout)
        }


    Timer {
        id:init
        running:false
        repeat:false
        interval:200
        onTriggered:{
            //selectedItem=movieArray;
            //listView.focus=true
            //listView.anchors.leftMargin=60;
            //listView.model=movieArray.length;
            //listView.delegate=movieView;
            randomGen(0,movieArray.length);
            selectedItem=randomArray;
            listView.positionViewAtBeginning();
            listView.anchors.leftMargin=500;
        }
    }


    QC25.TextField {
        id:tf
        placeholderText:"Movie Search..."
        anchors.top:root.top
        anchors.rightMargin:80
        anchors.topMargin:70
        anchors.right:root.right
        antialiasing:true
        opacity: .75
        width:280
        height:36
        visible:selectedItem==movieArray
        onAccepted: {
            searchMovies (tf.text)
            // tfTimer.start();
        }
        focus:false //listView.delegate==movies
        //font.color:  "white"
        placeholderTextColor:"gray"

        background: Rectangle {
            radius: 8
            border.color: parent.focus ? "cyan":"gray"
            border.width: 1
            width:parent.width
            height:parent.height
            color: "black"
            antialiasing:true

            IconItem {
                source:"editclear"
                width:36
                height:30
                smooth:true
                visible:tf.text.length>0
                anchors.top:parent.top
                anchors.right:parent.right
                anchors.topMargin:4
                anchors.rightMargin:-27

                MouseArea {
                    anchors.fill: parent
                    cursorShape:  Qt.PointingHandCursor
                    hoverEnabled:true
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                    onClicked:tf.text=""
                }
            }
        }

        Timer {
            id:tfTimer
            running:tf.focus
            repeat:false
            interval:10000
            onTriggered:tf.text=""
        }
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
        var n=0;
        var p=0;

        for (let i = 0; i < 5; i++) {
            if (usedArray.length >= movieArray.length) {
                usedArray=[]; // reset went thru entire movie list //
            }
            do {
                n = Math.floor(Math.random() * (max - min + 1)) + min;
                p = usedArray.includes(n);
                if(!p){
                usedArray.push(n);
                r1.push(n);
                }
            }
            while(p);
        }

        randomArray=r1;
        r1=null;
        n=0;
        p=0;
        listView.model=randomArray.length;
        listView.delegate=movieView;
        listView.positionViewAtBeginning();
        return null;
    }

    function searchMovies (s) {
        if (typeof(movieArray) != "undefined") {
            searchArray = movieArray.filter(x => x.title.toLowerCase().includes(s.toLowerCase()));
            selectedItem=searchArray;
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

    Component {
        id:movieView

        Rectangle { width:185;height:295;
            color:"black";
            border.color:"lightgray"
            border.width:2;
            radius: 8;
            antialiasing:true

            Image {
                source: (selectedItem===randomArray) ? "images/"+movieArray[randomArray[index]].poster.split("/").pop()  : (selectedItem===movieArray) ? "images/"+movieArray[index].poster.split("/").pop() : (selectedItem===tvArray) ? "images/"+tvArray[index].poster.split("/").pop() : (selectedItem===searchArray) ? (searchArray.length > 0) ? "images/"+searchArray[index].poster.split("/").pop() : "images/movie-poster-credits-178.jpg" : "images/movie-poster-credits-178.jpg"
                fillMode : Image.PreserveAspectFit
                height:parent.height*.87
                anchors.top:parent.top
                anchors.topMargin:4
                anchors.horizontalCenter:parent.horizontalCenter
                //antialiasing:true
                cache:true
                asynchronous : false


                Text {
                    anchors.top:parent.bottom
                    anchors.left:parent.left
                    anchors.topMargin:10
                    anchors.leftMargin:5
                    text:(selectedItem===randomArray) ? movieArray[randomArray[index]].title : (selectedItem===movieArray) ? movieArray[index].title : (selectedItem===tvArray) ? tvArray[index].title : (selectedItem===searchArray) ?  (searchArray.length > 0) ?searchArray[index].title:"No Results" : "No Results"
                    color:"white"
                    antialiasing:true
                    font.pointSize:11
                    width:165
                    elide: Text.ElideRight
                    wrapMode: Text.NoWrap
                }
            }

            MouseArea {
                //id:ma
                anchors.fill: parent
                hoverEnabled:true
                cursorShape:  Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                onEntered:{
                    parent.border.color="cyan"
                    //currentIndex=index
                    parent.y+=5
                    //QC25.ToolTip.font.pointSize=14
                    //QC25.ToolTip.x = mouseX
                    //QC25.ToolTip.y = mouseY
                    //QC25.ToolTip.delay=3000;
                    //QC25.ToolTip.visible=true;
                    //QC25.ToolTip.timeout=10000;
                    //QC25.ToolTip.text=(selectedItem===randomArray) ? movieArray[randomArray[index]].synopsis : (selectedItem===movieArray) ? movieArray[index].synopsis : (selectedItem===tvArray) ? tvArray[index].synopsis : (selectedItem===searchArray) ?  (searchArray.length > 0) ?searchArray[index].synopsis:"No Results" : "No Results"
                    //movieArray[randomArray[index]].synopsis
                }
                onExited:{
                    parent.y-=5
                    parent.border.color="lightgray"
                    //QC25.ToolTip.visible=false;
                    //QC25.ToolTip.text=""
                }
                onClicked:{
                    selectedMovie=(selectedItem===randomArray) ? movieArray[randomArray[index]].title : (selectedItem===movieArray) ? movieArray[index].title : (selectedItem===tvArray) ? tvArray[index].title : (selectedItem===searchArray) ?  (searchArray.length > 0) ? searchArray[index].title : "No Results" : "No Results"

                    selectedMoviePlaylist=(selectedItem===randomArray) ? movieArray[randomArray[index]].playlist : (selectedItem===movieArray) ? movieArray[index].playlist : (selectedItem===searchArray) ?  (searchArray.length > 0) ? searchArray[index].playlist:"No Results" : "No Results"

                    selectedMovieSubtitle = movieArray[index].subtitle ? movieArray[index].subtitle :" "

                    if (mouse.button == Qt.LeftButton) {
                        (selectedItem===randomArray) ? Qt.openUrlExternally(movieArray[randomArray[index]].link1) :
                        (selectedItem===movieArray) ? Qt.openUrlExternally(movieArray[index].link1) : (selectedItem===searchArray) ? Qt.openUrlExternally(searchArray[index].link1) : (selectedItem===tvArray) ? Qt.openUrlExternally(tvArray[index].link) : Qt.openUrlExternally("https://moviesjoyhd.to/home")
                    }
                    if (mouse.button == Qt.MiddleButton) {

                        selectedItem!=tvArray ? executable.exec(mpvCMD):Qt.openUrlExternally(tvArray[index].link)
                    }
                    //Qt.openUrlExternally(tvArray[index].link)
                }
            }
        }
    }

     Rectangle {
            anchors.top:root.top
            anchors.left:root.left
            width:124
            height:84
            radius:12
            anchors.margins:20
            color:"gray"
            border.color:"gray"
            border.width:.5
            opacity:.25
            antialiasing:true


        Text {
            text:"BlueBoxx"
            color:"white";
            font.pointSize:22;font.family:"Komika Title";
            //anchors.top:root.top;anchors.horizontalCenter:parent.horizontalCenter;
            anchors.centerIn:parent
            antialiasing:true
        }
     }

    Item {
        id:headerView
        height:85
        width:parent.width
        anchors.top:root.top
        anchors.topMargin:36
        anchors.horizontalCenter:parent.horizontalCenter
        //z:2

            Row {
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.top:headerView.top
                anchors.topMargin:15
                spacing:60

                Rectangle {
                    width:156;height:36;
                    color:"transparent"
                    border.color:(selectedItem===randomArray) ? "cyan":"gray"
                    radius:8
                    antialiasing:true


                    Text {text:"Now Showing"
                        color:"white"
                        font.family:"Komika Title"
                        font.pointSize:20
                        anchors.horizontalCenter:parent.horizontalCenter
                        anchors.verticalCenter:parent.verticalCenter
                        antialiasing:true
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape:  Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                        onEntered:parent.border.color="cyan"
                        onExited:parent.border.color="gray"
                        hoverEnabled:true
                        onClicked: {
                            randomGen(0,movieArray.length);
                            tf.focus=false
                            tf.text=""
                            listView.focus=true
                            selectedItem=randomArray;
                            listView.anchors.leftMargin=500;
                            listView.model=randomArray.length;
                            listView.delegate=null;
                            listView.delegate=movieView;
                        }
                    }
                }

                Rectangle {
                    width:156;height:36;
                    color:"transparent"
                    border.color:(selectedItem===movieArray) ? "cyan":"gray"
                    radius:8
                    antialiasing:true

                    Text {text:"Movies"
                        color:"white"
                        font.family:"Komika Title"
                        font.pointSize:20
                        anchors.horizontalCenter:parent.horizontalCenter
                        anchors.verticalCenter:parent.verticalCenter
                        antialiasing:true
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape:  Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                        onEntered:parent.border.color="cyan"
                        onExited:parent.border.color="gray"
                        hoverEnabled:true
                        onClicked: {
                            selectedItem=movieArray;
                            tf.focus=false
                            tf.text=""
                            listView.focus=true
                            listView.anchors.leftMargin=60;
                            listView.positionViewAtBeginning();
                            listView.model=movieArray.length;
                            listView.delegate=null;
                            listView.delegate=movieView;
                        }
                    }
                }

                Rectangle {
                    width:156;height:36;
                    color:"transparent"
                    border.color:(selectedItem===tvArray) ? "cyan":"gray"
                    radius:8
                    antialiasing:true

                    Text {text:"TV Series"
                        color:"white"
                        font.family:"Komika Title"
                        font.pointSize:20
                        anchors.horizontalCenter:parent.horizontalCenter
                        anchors.verticalCenter:parent.verticalCenter
                        antialiasing:true
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape:  Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                        onEntered:parent.border.color="cyan"
                        onExited:parent.border.color="gray"
                        hoverEnabled:true
                        onClicked: {
                            selectedItem=tvArray;
                            tf.focus=false
                            listView.focus=true
                            tf.text=""
                            listView.anchors.leftMargin=60;
                            listView.model=tvArray.length;
                            listView.delegate=null;
                            listView.delegate=movieView;
                        }
                    }
                }
            }

        Rectangle {
            id:ts1
            anchors.top:parent.bottom
            anchors.topMargin:15
            anchors.horizontalCenter:parent.horizontalCenter
            width:root.width/1.03
            height:.5
            color:"gray"
            antialiasing:true
        }
}

    QC15.ScrollView {
        id: scrollView
        anchors.top:headerView.bottom
        anchors.bottom:root.bottom
        anchors.left:root.left
        anchors.right:root.right
        anchors.topMargin:30
        anchors.leftMargin:5
        anchors.rightMargin:5
        anchors.bottomMargin:0
        clip:false
        width:root.width
        height:root.height-160
        enabled : hovered || pressed
        __wheelAreaScrollSpeed: 310 /// set scroll page height pixels

        GridView {
            id:listView
            focus:true
            visible:false
            anchors.top:parent.top
            anchors.bottom:parent.bottom
            anchors.left:parent.left
            anchors.right:parent.right
            width:parent.width
            height:parent.height
            model:selectedItem.length
            boundsBehavior: Flickable.StopAtBounds
            cacheBuffer:310*27
            //highlight:highlightView
            clip:false
            interactive:false
            snapMode :GridView.SnapOneRow
            //keyNavigationEnabled: true
            //keyNavigationWraps: false // endless scrolling
            delegate:null
            cellWidth: 200; cellHeight: 310
            onDelegateChanged:{
                opacity=0;
                opacity=1;}
                Behavior on opacity {
                    OpacityAnimator {
                        duration: units.longDuration
                        easing.type: Easing.InCubic
                    }}
            Component.onCompleted: {
                listView.visible=true;
            }

        }
    }
}
