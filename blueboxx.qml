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
    //source:"/home/data/Pictures/wallpapers/bk11.jpg"
    property var movieArray:{}
    property var tvArray:{}
    property var randomArray:[]
    property var searchArray:[]
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
            randomGen(0,movieArray.length);
            selectedItem=randomArray;
            listView.positionViewAtBeginning();
            listView.anchors.leftMargin=500;
        }
    }


    QC25.TextField {
        id:tf
        placeholderText:"Movie Search..."//+movieArray.length
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
        }
        focus:false
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
        var n1=0;
        for (x=0;x<5;x++) {
            n1=Math.floor(Math.random() * (max - min - x) );
            r1.includes(n1) ? n1=Math.floor(Math.random() * (max - min - x) ) : n1=n1 // check for repeats
            r1.push(n1);
        }
        randomArray=r1;
        r1=null;
        n1=0;
        listView.model=randomArray.length;
        listView.delegate=movieView;
        listView.positionViewAtBeginning();
        return null;
    }

    function searchMovies (s) {
        if (typeof(movieArray) != "undefined") {
            searchArray = movieArray.filter(x => x.title.toLowerCase().includes(s.toLowerCase()));
            selectedItem=searchArray;
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
                id:posterArt
                source: (selectedItem===randomArray) ? "images/"+movieArray[randomArray[index]].poster.split("/").pop()  : (selectedItem===movieArray) ? "images/"+movieArray[index].poster.split("/").pop() : (selectedItem===tvArray) ? "images/"+tvArray[index].poster.split("/").pop() : (selectedItem===searchArray) ? (searchArray.length > 0) ? "images/"+searchArray[index].poster.split("/").pop() : "images/movie-poster-credits-178.jpg" : "images/movie-poster-credits-178.jpg"
                fillMode : Image.PreserveAspectFit
                height:parent.height*.87
                anchors.top:parent.top
                anchors.topMargin:4
                anchors.horizontalCenter:parent.horizontalCenter
                cache:true
                asynchronous:false
                visible:true
                opacity:1


                Text {
                    id:title
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
                    visible:true
                }
            }


            Text {
                id:synopsis
                anchors.top:parent.top
                anchors.left:parent.left
                anchors.topMargin:10
                anchors.leftMargin:10
                text:(selectedItem===randomArray) ? movieArray[randomArray[index]].synopsis : (selectedItem===movieArray) ? movieArray[index].synopsis : (selectedItem===tvArray) ? tvArray[index].synopsis : (selectedItem===searchArray) ?  (searchArray.length > 0) ?searchArray[index].synopsis:"No Results" : "No Results"
                color:"white"
                antialiasing:true
                font.pointSize:12
                width:170
                height:290
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                visible:false
            }
            MouseArea {
                id:ma
                anchors.fill: parent
                hoverEnabled:true
                //preventStealing : true
                cursorShape:  Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                onEntered:{
                    parent.border.color="cyan";
                    toolTipTimer.start();
                    parent.y+=5;
                }
                onExited:{
                    parent.y-=5;
                    parent.border.color="lightgray";
                    synopsis.visible=false;
                    posterArt.opacity=1;
                    toolTipTimer.stop();
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
                }
            }

            Timer {
                id:toolTipTimer
                running:false
                repeat:false
                interval:2000
                onTriggered:{
                    posterArt.opacity=.25
                    synopsis.visible=true
                }
            }
        }
    }

    Rectangle {
        id:logoBox
        anchors.top:root.top
        anchors.left:root.left
        width:124
        height:64
        radius:12
        anchors.margins:20
        color:"gray"
        border.color:"lightgray"
        border.width:.5
        opacity:.25
        antialiasing:true
    }

        Text {
            text:"BlueBoxx"
            color:"#00aaff"
            font.pointSize:22;font.family:"Komika Title";
            anchors.centerIn:logoBox
            antialiasing:true
        }

    Item {
        id:headerView
        height:75
        width:parent.width
        anchors.top:root.top
        anchors.topMargin:36
        anchors.horizontalCenter:parent.horizontalCenter

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


                Text {
                    text:"Now Showing"
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

                Text {
                    text:"Movies"
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

                Text {
                    text:"TV Series"
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
            color:"white"
            antialiasing:true
        }
    }

    QC15.ScrollView {
        id: scrollView
        anchors.top:headerView.bottom
        anchors.bottom:root.bottom
        anchors.left:root.left
        anchors.right:root.right
        anchors.topMargin:40
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
