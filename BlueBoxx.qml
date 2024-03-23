import QtQuick 2.9
import QtQuick.Layouts 1.5
import QtQuick.Controls 2.5 as QC25
import QtQuick.Controls 1.5 as QC15
import org.kde.plasma.components 2.0
import org.kde.plasma.core 2.1
import QtGraphicalEffects 1.5

// *** blueboxx media manager app
// *** txhammer
// *** 03/2024
// *** json arrays for movie/tv shows

Image {
    id:root
    anchors.fill:rootMain
    anchors.margins:0
    source:"bk2.png"
    property var movieArray:[]
    property var tvArray:[]
    property var randomArray:[]
    property var searchArray:[]
    property string selectedItem:"randomList"
    property int currentItem:0
    property string url1:"movies.json"
    property string url2:"tvList.json"
    property string selectedMovie:""
    property string selectedMoviePlaylist:""

    property string movieDir:"/$HOME/Movies/"
    property string tvDir:"/$HOME/tvSeries/"
    property string trailerDir:"/$HOME/Movies/Trailers/"


     FontLoader {
        id: appFontStyle
        source: "KomikaTitle.ttf"
    }


    Component.onCompleted: {
        scripts.getData(url1);
        scripts.getData(url2);
        init.start();
    }

    Scripts {id:scripts}

    Search {id: searchPopup}

    Info { id: mediaInfoPopup}

    TV {id:tvSeriesPopup}


    Timer {
        id:init
        running:false
        repeat:false
        interval:200
        onTriggered:{
            //scripts.randomGen(0,movieArray.length);
            scripts.newMovies()
            listView.positionViewAtBeginning();
            listView.anchors.leftMargin=500;
        }
    }


    QC25.TextField {
        id:tf
        placeholderText:"Movie Search...\t "+"                   ("+movieArray.length+")".replace(" ",'&#32')
        anchors.top:root.top
        anchors.rightMargin:80
        anchors.topMargin:50
        anchors.right:root.right
        antialiasing:true
        opacity: .75
        width:280
        height:36
        visible:selectedItem=="movieList" || selectedItem=="searchList"
        onAccepted: {
            scripts.searchMovies (tf.text)
        }
        focus:false
        placeholderTextColor:"gray"

        background: Rectangle {
            radius: 8
            border.color: parent.focus ? "#55aaff":"gray"
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

        Text {
            anchors.top:tf.bottom
            anchors.left:tf.right
            anchors.topMargin:10
            anchors.leftMargin:-135
            text:"Advanced Search"
            color:"white"
            visible:selectedItem=="movieList" || selectedItem=="searchList"
            font.pointSize:12
            antialiasing:true

            MouseArea {
                anchors.fill: parent
                cursorShape:  Qt.PointingHandCursor
                hoverEnabled:true
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                onEntered:{
                    parent.color="#55aaff"
                }
                onExited:{
                    parent.color="white"
                }
                onClicked:searchPopup.open()
            }
        }

        Timer {
            id:tfTimer
            running:tf.focus
            repeat:false
            interval:10000
            onTriggered:{
                tf.text=""
                tf.focus=false
            }
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
                height:parent.height*.87
                anchors.top:parent.top
                anchors.topMargin:4
                anchors.horizontalCenter:parent.horizontalCenter
                //antialiasing:true
                smooth:true
                cache:true
                asynchronous : false

                Text {
                    anchors.top:parent.bottom
                    anchors.left:parent.left
                    anchors.topMargin:10
                    anchors.leftMargin:5
                    text:(selectedItem=="randomList") ? randomArray[index].title : (selectedItem=="movieList") ? movieArray[index].title : (selectedItem=="tvList") ? tvArray[index].name : (selectedItem=="searchList") ?  (searchArray.length > 0) ?searchArray[index].title:"No Results" : "No Results"
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
                    parent.border.color="#55aaff"
                    parent.y+=5
                }
                onExited:{
                    parent.y-=5
                    parent.border.color="lightgray"
                }
                onClicked:{
                    currentItem=-1
                    currentItem=index;
                    selectedItem=="tvList" ? tvSeriesPopup.open() : mediaInfoPopup.open();

                }
            }
        }
    }

    Rectangle {
        id:logoBox
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
    }

    Text {
        anchors.centerIn:logoBox
        text:"BlueBoxx"
        color:"#55aaff";
        font.pointSize:20;font.family:"Komika Title";
        antialiasing:true
    }

    Item {
        id:headerView
        height:85
        width:parent.width/2
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
                border.color:(selectedItem=="randomList") ? "#55aaff":"gray"
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
                    onEntered:parent.border.color="#55aaff"
                    onExited:parent.border.color="gray"
                    hoverEnabled:true
                    onClicked: {
                        randomArray=[]
                        scripts.randomGen(0,movieArray.length);
                        searchArray=[]
                        tf.focus=false
                        tf.text=""
                        listView.focus=true
                        selectedItem="randomList"
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
                border.color:(selectedItem=="movieList") ? "#55aaff":"gray"
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
                    onEntered:parent.border.color="#55aaff"
                    onExited:parent.border.color="gray"
                    hoverEnabled:true
                    onClicked: {
                        selectedItem="movieList"
                        randomArray=[]
                        searchArray=[]
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
                border.color:(selectedItem=="tvList") ? "#55aaff":"gray"
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
                    onEntered:parent.border.color="#55aaff"
                    onExited:parent.border.color="gray"
                    hoverEnabled:true
                    onClicked: {
                        randomArray=[]
                        searchArray=[]
                        selectedItem="tvList"
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

    function selectedView () {

        if (selectedItem == "randomList")
            return randomArray.length
            else if (selectedItem == "movieList")
                return movieArray.length
                else if (selectedItem == "searchList")
                    return searchArray.length
                    else if (selectedItem == "tvList")
                        return tvArray.length
                        else return 1
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
        focus:true
        width:root.width
        height:root.height
        enabled : hovered || pressed
        __wheelAreaScrollSpeed: 310 /// set scroll page height pixels

        Component.onCompleted: {
            focus=true
        }

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
            model:selectedView ()
            boundsBehavior: Flickable.StopAtBounds
            cacheBuffer:256//310*27
            //reuseItems :true
            //highlight:highlightView
            //highlightFollowsCurrentItem:true
            clip:false
            interactive:true
            snapMode :GridView.SnapOneRow
            keyNavigationEnabled: true
            //keyNavigationWraps : true
            Keys.onPressed:{
                if(event.key === Qt.Key_PageUp){
                listView.flick(0, contentY-=310)
                    }
                else if(event.key === Qt.Key_PageDown){
                listView.flick(0, contentY+=310)
                    }
                else if(event.key === Qt.Key_Home){
                listView.positionViewAtBeginning()
                    }
                else if(event.key === Qt.Key_End){
                listView.positionViewAtEnd()
                    }
            }
            Keys.onUpPressed: listView.flick(0, contentY-=310)
            Keys.onDownPressed: listView.flick(0, contentY+=310)
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
                  //listView.positionViewAtIndex(1)
                  //listView.incrementCurrentIndex()
                }

            Behavior on contentY{
            NumberAnimation {
                duration: 1000
                easing.type: Easing.OutQuad
            }
        }
        }
    }
}
