import QtQuick 2.9
import QtQuick.Layouts 1.5
import QtQuick.Controls 2.5 as QC25
import org.kde.plasma.components 2.0
import org.kde.plasma.core 2.1
import QtGraphicalEffects 1.5

Image {
    id:root
    anchors.fill:rootMain
    source:"bk4.jpg"

    readonly property color highLightColor:"#00aaff" //"#00aaff" //"#55aaff"
    property var movieArray:[]
    property var tvArray:[]
    property string tvGenres:""
    property var randomArray:[]
    property var searchArray:[]
    property var collectionArray:[]
    property var usedArray:[]
    property int collectionCount:0
    property int collectionItems:0
    property int movieCount:-1
    property int idx:0
    property string selectedItem:"randomList"
    property int currentItem:-1
    property int currentCollectionItem:-1
    property bool keysActive:false
    readonly property string url1:"movies.json"
    readonly property string url2:"tvList.json"
    readonly property string movieDir:"/home/data/Movies/"
    readonly property string tvDir:"/home/data/tvSeries/"
    readonly property string trailerDir:"/home/data/Movies/Trailers/"

    FontLoader {
        id: appFontStyle
        source: "KomikaTitle.ttf"
    }

    Scripts {id:scripts}
    Collections {id:collectionsPopup}
    CollectionsInfo {id:collectionInfo}
    TV {id:tvSeriesPopup}
    Search {id: searchPopup}
    Info { id: mediaInfoPopup}
    //AddMovie{id:addMovie}

    QC25.TextField {
        id:tf
        placeholderText:"Movie Search...\t "+"                   ("+movieCount+")".replace(" ",'&#32')
        anchors.top:root.top
        anchors.right:root.right
        anchors.rightMargin:80
        anchors.topMargin:50
        width:280
        height:36
        visible:selectedItem=="movieList" || selectedItem=="searchList"
        antialiasing:true
        opacity:.75
        onAccepted: {
            selectedItem="searchList";
            scripts.searchMovies (tf.text);
            scripts.selectedViewChanged ();
            let s1=tf.text
            tf.text=""
            tf.placeholderText="Movie Search...\t "+"                   ("+movieCount+")".replace(" ",'&#32')
           }
        focus:false
        placeholderTextColor:"gray"

        background: Rectangle {
            width:parent.width
            height:parent.height
            color: "black"
            radius: 8
            border.color: parent.focus || selectedItem=="searchList" ? highLightColor:"gray" //
            border.width: 1
            antialiasing:true
            smooth:true

            IconItem {
                source:"editclear"
                width:36
                height:30
                smooth:true
                antialiasing:true
                visible:tf.text.length>0
                anchors.top:parent.top
                anchors.left:parent.right
                anchors.topMargin:4

                MouseArea {
                    anchors.fill: parent
                    cursorShape:  Qt.PointingHandCursor
                    hoverEnabled:true
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                    onClicked:{
                        tf.text="";
                        tf.focus=true;
                    }
                }
            }
        }
    }

        Text {
            anchors.top:tf.bottom
            anchors.right:tf.right
            anchors.topMargin:10
            text:"Advanced Search"
            color:"white"
            font.pointSize:12
            antialiasing:true
            visible:selectedItem=="movieList" || selectedItem=="searchList"

            MouseArea {
                anchors.fill: parent
                cursorShape:  Qt.PointingHandCursor
                hoverEnabled:true
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                onEntered:parent.color=highLightColor
                onExited:parent.color="white"
                onClicked: searchPopup.open()
          }
      }

    Component {
        id:movieView

        Rectangle { width:185;height:295; // slightly smaller than Gridview cell height, cell width
            color:"black";
            border.color:"lightgray"
            border.width:2;
            radius: 4;
            antialiasing:true
            smooth:true

                Text {
                    anchors.bottom:parent.bottom
                    anchors.left:parent.left
                    anchors.bottomMargin:4
                    anchors.leftMargin:8
                    text:(selectedItem=="randomList" ) ? randomArray[index].title : (selectedItem=="movieList" ) ? movieArray[index].title : (selectedItem=="tvList") ? tvArray[index].name : (selectedItem=="searchList" ) ?  (searchArray.length > 0) ? searchArray[index].title:"No Results" : "No Results"
                    color:"white"
                    antialiasing:true
                    font.pointSize:11
                    width:parent.width*.95
                    elide: Text.ElideRight
                    wrapMode: Text.NoWrap
                }

            Image {
                source: (selectedItem=="randomList" ) ? "./posters"+randomArray[index].poster_path  : (selectedItem=="movieList" ) ? "./posters"+movieArray[index].poster_path : (selectedItem=="tvList" ) ? "./posters/"+tvArray[index].poster_path : (selectedItem=="searchList" ) ? (searchArray.length > 0) ? "./posters"+searchArray[index].poster_path : "./posters/movie-poster-credits-178.jpg" : "./posters/movie-poster-credits-178.jpg"
                fillMode : Image.PreserveAspectFit
                //sourceSize.height:parent.height*.87
                sourceSize.width:parent.width*.96
                anchors.top:parent.top
                anchors.topMargin:4
                anchors.horizontalCenter:parent.horizontalCenter
                smooth: true
                antialiasing: true
                mipmap: true
                cache:true
                asynchronous:false

                }

            MouseArea {
                anchors.fill: parent
                hoverEnabled:false
                cursorShape:  Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                onEntered:{
                    parent.border.color=highLightColor//"#55aaff"
                    parent.y+=5
                }
                onExited:{
                    parent.y-=5
                    parent.border.color="lightgray"
                }
                onClicked:{
                    currentItem=-1
                    currentItem=index;
                    if (selectedItem=="tvList"){
                        tvSeriesPopup.open();
                        scripts.tvGenre(); }
                    if (selectedItem=="randomList")
                        if (randomArray[index].hasOwnProperty("collection")) {
                            collectionArray=randomArray[index];
                            currentCollectionItem=index;
                            collectionsPopup.open();
                        }
                        else  mediaInfoPopup.open();
                    if (selectedItem=="movieList")
                        if (movieArray[index].hasOwnProperty("collection")) {
                            collectionArray=movieArray[index];
                            currentCollectionItem=index;
                            collectionsPopup.open();
                        }
                        else  mediaInfoPopup.open();
                    if (selectedItem=="searchList")
                        if (searchArray[index].hasOwnProperty("collection")) {
                            collectionArray=searchArray[index];
                            currentCollectionItem=index;
                            collectionsPopup.open();
                        }
                    else  mediaInfoPopup.open();
                }

                Timer {
                    running:true
                    repeat:false
                    interval:500
                    onTriggered:parent.hoverEnabled=true
                }
            }
        }
    }

        Image {
            id:logo
            source:"logo.png"
            width:124
            height:64
            anchors.top:root.top
            anchors.left:root.left
            anchors.topMargin:20
            anchors.leftMargin:60
            anchors.bottomMargin:20
            antialiasing:true
            smooth:true
        }


    Text {
        id:logoText
        anchors.top:logo.bottom
        anchors.left:logo.left
        anchors.topMargin:5
        anchors.leftMargin:-25
        leftPadding:10
        text:"BlueBoxx"
        color:"white" //"#55aaff"
        font.pointSize:18
        font.letterSpacing: 10
        font.family:"Komika Title"
        antialiasing:true
        font.weight : Font.Light
        //visible:false
        //style: Text.Outline
        //styleColor: "lightgray"
    }

     Keys.onPressed:{
                if (event.key ==  Qt.Key_Control ) {
                    if (selectedItem=="randomList") {
                        event.accepted = true;
                        scripts.selectedViewChanged ();
                    }
                }
        }

    Keys.onTabPressed: {
                if (selectedItem=="randomList") {
                    event.accepted = true;
                    selectedItem="movieList";
                    scripts.selectedViewChanged ();
                }
                else if (selectedItem=="movieList") {
                    event.accepted = true;
                    selectedItem="tvList";
                    scripts.selectedViewChanged ();
                }
                else if (selectedItem=="tvList") {
                    event.accepted = true;
                    selectedItem="randomList";
                    scripts.selectedViewChanged ();
                }
                else event.accepted = false;
        }

    Item {
        id:headerView
        anchors.top:root.top
        anchors.topMargin:40
        anchors.horizontalCenter:root.horizontalCenter
        height:80
        width:root.width*.96

        Row {
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.top:parent.top
            anchors.topMargin:15
            spacing:60

            Rectangle {
                id:r1
                width:166;height:36;
                color:"transparent"
                border.width:1
                border.color:"gray"
                radius:6
                antialiasing:true
                smooth:true
                z:-1

                RectangularGlow {
                    id: effect
                    anchors.fill: parent
                    glowRadius: 10
                    spread: 0.15
                    color: (selectedItem=="randomList" || ma1.containsMouse) ? highLightColor : "transparent"
                    cornerRadius: 8
                    smooth:true
                }


                Text {
                    anchors.centerIn:parent
                    text:"Now Showing"
                    color:"white"
                    font.family:"Komika Title"
                    font.pointSize:20
                    font.letterSpacing: 2
                    antialiasing:true
                }

                MouseArea {
                    id:ma1
                    anchors.fill: parent
                    cursorShape:  Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                    hoverEnabled:true;
                    onClicked: {
                        if (mouse.button==Qt.LeftButton){
                        selectedItem="randomList";
                        scripts.selectedViewChanged ();
                        }
                        else if (mouse.button==Qt.MiddleButton){
                            selectedItem="randomList";
                            randomArray=[];
                            scripts.newMovies ();
                        }
                    }
                }
            }

            Rectangle {
                id:r2
                width:162;height:36;
                color:"transparent"
                border.color:"gray"
                border.width:1
                radius:6
                antialiasing:true
                smooth:true

                RectangularGlow {
                    id: effect2
                    anchors.fill: parent
                    glowRadius: 10
                    spread: 0.15
                    color: (selectedItem=="movieList" || ma2.containsMouse) ? highLightColor : "transparent"
                    cornerRadius: 8
                    smooth:true
                }

                Text {text:"Movies"
                    color:"white"
                    font.family:"Komika Title"
                    font.pointSize:20
                    font.letterSpacing: 4
                    anchors.centerIn:parent
                    antialiasing:true
                }

                MouseArea {
                    id:ma2
                    anchors.fill: parent
                    cursorShape:  Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                    hoverEnabled:true
                    onClicked: {
                        selectedItem="movieList";
                        scripts.selectedViewChanged ();
                    }
                }
            }

            Rectangle {
                id:r3
                width:162;height:36;
                color:"transparent"
                border.color:"gray"
                border.width:1
                radius:6
                antialiasing:true
                smooth:true

                RectangularGlow {
                    id: effect3
                    anchors.fill: parent
                    glowRadius: 10
                    spread: 0.15
                    color: (selectedItem=="tvList" || ma3.containsMouse) ? highLightColor : "transparent"
                    cornerRadius: 8
                    smooth:true
                }

                Text {
                    anchors.centerIn:parent
                    text:"TV Series"
                    color:"white"
                    font.family:"Komika Title"
                    font.pointSize:20
                    font.letterSpacing: 4
                    antialiasing:true
                }

                MouseArea {
                    id:ma3
                    anchors.fill: parent
                    cursorShape:  Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                    hoverEnabled:true
                    onClicked: {
                        selectedItem="tvList";
                        scripts.selectedViewChanged ();
                    }
                }
            }
        }

        Rectangle {
            id:ts1
            anchors.top:parent.bottom
            anchors.topMargin:10
            anchors.horizontalCenter:parent.horizontalCenter
            width:root.width*.96
            height:.5
            color:"gray"
            antialiasing:true
            smooth:true
        }
    }
        GridView {
            id:listView
            focus:true
            visible:true
            opacity:0
            anchors.top:headerView.bottom
            anchors.bottom:parent.bottom
            anchors.left:parent.left
            anchors.right:parent.right
            width:parent.width
            height:parent.height-headerView.height-75
            cellWidth: 200; cellHeight: 315
            anchors.topMargin:30
            anchors.rightMargin:1
            model:1
            boundsBehavior: Flickable.StopAtBounds
            cacheBuffer:512
            QC25.ScrollBar.vertical: QC25.ScrollBar {
                id:vbar
                active:hovered || keysActive
                //policy: active ? "AlwaysOn" : "AlwaysOff"
                snapMode : "SnapOnRelease"
                contentItem: Rectangle {
                    id:rect1
                    implicitWidth: 4
                    //implicitHeight:contentItem.height/4
                    radius:6
                    color: "white"
                    antialiasing:true
                    smooth:true
                    opacity:vbar.active || keysActive  ? 1:0
                    Behavior on opacity {
                    OpacityAnimator {
                        duration: units.longDuration
                        easing.type: opacity ? Easing.OutCubic:Easing.InCubic
                    }}
                }
                background: Rectangle {
                    id:rect2
                    implicitWidth: 4
                    radius:6
                    opacity:vbar.active || keysActive  ? .45:0
                    color: "black"
                    antialiasing:true
                    smooth:true
                    Behavior on opacity {
                    OpacityAnimator {
                        duration: units.longDuration
                        easing.type: opacity ? Easing.OutCubic:Easing.InCubic
                    }}
                }
            }

            Timer{
                id:keyTimer
                running:false
                repeat:false
                interval:500
                onTriggered:keysActive=false
            }


            clip:true
            interactive:true
            snapMode :GridView.SnapToRow
            keyNavigationEnabled: true
            keyNavigationWraps : false

            Keys.onPressed:{
                if(event.key === Qt.Key_PageUp){
                    if (!atYBeginning) {
                        keysActive=true;
                        listView.flick(0, contentY-=630);
                    }
                }
                else if(event.key === Qt.Key_PageDown){
                    if (!atYEnd) {
                        keysActive=true;
                        listView.flick(0, contentY+=630);
                    }
                }
                else if(event.key === Qt.Key_Home){
                    keysActive=true;
                    keyTimer.start();
                    listView.positionViewAtBeginning();
                }
                else if(event.key === Qt.Key_End){
                    keysActive=true;
                    keyTimer.start();
                    listView.positionViewAtEnd();
                }
            }
            Keys.onUpPressed: {
                if (!atYBeginning) {
                    keysActive=true;
                    listView.flick(0, contentY-=315);
                }
            }
            Keys.onDownPressed:{
                 if (!atYEnd) {
                    keysActive=true;
                    listView.flick(0, contentY+=315)
                 }
            }
            delegate:null
            onDelegateChanged:{
                opacity=0;
                opacity=1;}
                Behavior on opacity {
                    OpacityAnimator {
                        duration: units.longDuration
                        easing.type: Easing.InCubic
                    }}
                    Component.onCompleted: {
                         listView.opacity=1;
                    }

                    Behavior on contentY{
                        // smooth scroll animation
                        NumberAnimation {
                            id:smoothScroll
                            duration: 1000
                            easing.type: Easing.OutQuad
                            onRunningChanged: !running ?  keyTimer.start() : ""

                        }
                    }
        }
}
