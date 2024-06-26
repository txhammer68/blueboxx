import QtQuick 2.9
import QtQuick.Layouts 1.5
import QtQuick.Controls 2.5 as QC25
import QtQuick.Controls 1.5 as QC15
import org.kde.plasma.components 2.0
import org.kde.plasma.core 2.1
import QtGraphicalEffects 1.5
import QtQuick.Controls.Styles 1.4

Image {
    id:root
    anchors.fill:rootMain
    source:"bk4.jpg"

    readonly property color highLightColor:"gold"
    property var movieArray:[]
    property var tvArray:[]
    property string tvGenres:""
    property var randomArray:[]
    property var searchArray:[]
    property var usedArray:[]
    property string selectedItem:"randomList"
    property int currentItem:0
    readonly property string url1:"movies.json"
    readonly property string url2:"tvList.json"
    readonly property string movieDir:"/home/data/Movies/"
    readonly property string tvDir:"/home/data/Movies/tvSeries/"
    readonly property string trailerDir:"/home/data/Movies/Trailers/"

    FontLoader {
        id: appFontStyle
        source: "KomikaTitle.ttf"
    }


    Scripts {id:scripts}

    Search {id: searchPopup}

    Info { id: mediaInfoPopup}

    TV {id:tvSeriesPopup}

    QC25.TextField {
        id:tf
        property int movieCount:searchArray.length > 0 ? searchArray.length : movieArray.length
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

            IconItem {
                source:"editclear"
                width:36
                height:30
                smooth:true
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

        Rectangle { width:185;height:295;
            color:"black";
            border.color:"lightgray"
            border.width:2;
            radius: 8;
            antialiasing:true

            Image {
                source: (selectedItem=="randomList") ? "posters"+randomArray[index].poster_path  : (selectedItem=="movieList") ? "posters"+movieArray[index].poster_path : (selectedItem=="tvList") ? "posters/"+tvArray[index].poster_path : (selectedItem=="searchList") ? (searchArray.length > 0) ? "posters"+searchArray[index].poster_path : "posters/movie-poster-credits-178.jpg" : "posters/movie-poster-credits-178.jpg"
                fillMode : Image.PreserveAspectFit
                sourceSize.height:parent.height*.87
                anchors.top:parent.top
                anchors.topMargin:4
                anchors.horizontalCenter:parent.horizontalCenter
                smooth: true
                antialiasing: true
                mipmap: true
                cache:true
                asynchronous:false

                Text {
                    anchors.top:parent.bottom
                    anchors.left:parent.left
                    anchors.topMargin:10
                    anchors.leftMargin:0
                    text:(selectedItem=="randomList") ? randomArray[index].title : (selectedItem=="movieList") ? movieArray[index].title : (selectedItem=="tvList") ? tvArray[index].name : (selectedItem=="searchList") ?  (searchArray.length > 0) ?searchArray[index].title:"No Results" : "No Results"
                    color:"white"
                    antialiasing:true
                    font.pointSize:11
                    width:parent.width*.95
                    elide: Text.ElideRight
                    wrapMode: Text.NoWrap
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled:true
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
                    else  mediaInfoPopup.open();

                }
            }
        }
    }

    Rectangle {
        id:logoBox
        anchors.top:root.top
        anchors.left:root.left
        anchors.margins:30
        width:124
        height:72
        radius:12
        color:"gray"
        //border.color:"gray"
        //border.width:.5
        opacity:.25
        antialiasing:true
    }

    Text {
        anchors.centerIn:logoBox
        text:"BlueBoxx"
        color:"#55aaff"
        font.pointSize:20
        font.family:"Komika Title"
        antialiasing:true
    }

    Item {
        id:headerView
        anchors.top:root.top
        anchors.topMargin:40
        anchors.horizontalCenter:root.horizontalCenter
        height:80
        width:root.width/2

        Row {
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.top:parent.top
            anchors.topMargin:15
            spacing:60

            Rectangle {
                id:r1
                width:156;height:36;
                color:"transparent"
                border.width:1
                border.color:(selectedItem=="randomList" || ma1.containsMouse) ? highLightColor : "gray"
                radius:8
                antialiasing:true


                Text {
                    anchors.centerIn:parent
                    text:"Now Showing"
                    color:"white"
                    font.family:"Komika Title"
                    font.pointSize:20
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
                width:156;height:36;
                color:"transparent"
                border.color:(selectedItem=="movieList" || ma2.containsMouse) ? highLightColor : "gray"
                border.width:1
                radius:8
                antialiasing:true

                Text {text:"Movies"
                    color:"white"
                    font.family:"Komika Title"
                    font.pointSize:20
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
                width:156;height:36;
                color:"transparent"
                border.color:(selectedItem=="tvList" || ma3.containsMouse) ? highLightColor : "gray"
                border.width:1
                radius:8
                antialiasing:true

                Text {
                    anchors.centerIn:parent
                    text:"TV Series"
                    color:"white"
                    font.family:"Komika Title"
                    font.pointSize:20
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
        anchors.bottomMargin:1
        width:root.width
        height:root.height-headerView.height
        clip:false
        focus:true
        verticalScrollBarPolicy : Qt.ScrollBarAsNeeded
        enabled : hovered || pressed
        __wheelAreaScrollSpeed: 310
        style: ScrollViewStyle {
        transientScrollBars:true
        scrollToClickedPosition : true
        handle: Rectangle {
            implicitWidth: 8
            //implicitHeight: 400
            color: "white"
            opacity:.85
            radius:12
        }
        scrollBarBackground: Rectangle {
            implicitWidth: 8
            //implicitHeight: parent.height
            color: "black"
            radius:12
            opacity:.25
        }
    }


        GridView {
            id:listView
            focus:true
            visible:true
            parent:scrollView
            anchors.top:parent.top
            anchors.bottom:parent.bottom
            anchors.left:parent.left
            anchors.right:parent.right
            width:parent.width
            height:parent.height
            model:1
            boundsBehavior: Flickable.StopAtBounds
            cacheBuffer:256
            clip:true
            interactive:false
            snapMode :GridView.SnapOneRow
            keyNavigationEnabled: true
            keyNavigationWraps : false
            Keys.onPressed:{
                if(event.key === Qt.Key_PageUp){
                    if (!atYBeginning) {
                    listView.flick(0, contentY-=620);}
                }
                else if(event.key === Qt.Key_PageDown){
                    if (!atYEnd) {
                       listView.flick(0, contentY+=620)
                    }
                }
                else if(event.key === Qt.Key_Home){
                    listView.positionViewAtBeginning()
                }
                else if(event.key === Qt.Key_End){
                    listView.positionViewAtEnd()
                }
            }
            Keys.onUpPressed: {
                if (!atYBeginning) {
                listView.flick(0, contentY-=310)
                } }
            Keys.onDownPressed:{
                 if (!atYEnd) {
                listView.flick(0, contentY+=310)
                 } }
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

                    Behavior on contentY{ // smooth scroll animation
                        NumberAnimation {
                            duration: 1000
                            easing.type: Easing.OutQuad
                        }
                    }
        }
    }
}
