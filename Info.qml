import QtQuick 2.9
import QtQuick.Controls 2.5 as QC25
import org.kde.plasma.components 2.0
import org.kde.plasma.core 2.1
import QtMultimedia 5.9
import QtGraphicalEffects 1.5

QC25.Popup {
    anchors.centerIn: parent
    width: 1400
    height: 900
    modal: true
    focus: true
    property real backdropOpacity: 1.0
    property color backdropColor:"black"
    //closePolicy: mediaInfoPopup.CloseOnEscape || mediaInfoPopup.CloseOnPressOutsideParent || mediaInfoPopup.CloseOnPressOutside

    onClosed: {
        //summary.visible=true
        mplayer.stop();
        overlayRect.visible=false;
        mplayer.source="";
        Qt.cursorShape=Qt.ArrowCursor;
    }

    QC25.Overlay.modal: GaussianBlur {
        source: ShaderEffectSource {
            sourceItem: bluebox
            live: false
        }
        radius: 16
        samples: radius * 2
    }

    enter: Transition {
        NumberAnimation {
            property: "scale";
            from: 0.6;
            to: 1.0;
            easing.type: Easing.OutBack
            duration: 750
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "scale";
            from: 1.0
            to: 0.6;
            easing.type: Easing.InBack
            duration: 300
        }
    }

    background: Rectangle {
        border.color: "gray"
        border.width:.5
        antialiasing:true
        color:"black"
        radius:8

        Image{
            source:(selectedItem=="randomList") ? "backdrops"+randomArray[currentItem].backdrop_path : (selectedItem=="movieList") ? "backdrops"+movieArray[currentItem].backdrop_path : (selectedItem=="tvList") ? "backdrops/"+tvArray[currentItem].backdrop_path : (selectedItem=="searchList") ?  (searchArray.length > 0) ? "backdrops"+searchArray[currentItem].backdrop_path:"-" : "-"
            anchors.centerIn:parent
            width:parent.width*.994
            height:parent.height*.994
            fillMode : Image.PreserveAspectCrop
            opacity:1
            smooth:true
            //antialiasing:true
        }

        Rectangle {
            id:titleBox
            anchors.top:parent.top
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.topMargin:20
            width:titleHeaderHidden.width+(titleHeaderHidden.width/3)
            height:titleHeaderHidden.height+10
            color:"black"
            opacity:.65
            radius:12
            antialiasing:true
        }

        Text {
            id:titleHeaderHidden
            anchors.centerIn:titleBox
            text:(selectedItem=="randomList") ? randomArray[currentItem].title : (selectedItem=="movieList") ? movieArray[currentItem].title : (selectedItem=="tvList") ? tvArray[currentItem].name : (selectedItem=="searchList") ?  (searchArray.length > 0) ?searchArray[currentItem].title:"-" : "-"
            color:"white"
            visible:false
            antialiasing:true
            font.pointSize:36
        }

        Text {
            id:titleHeader
            anchors.centerIn:titleBox
            text:(selectedItem=="randomList") ? randomArray[currentItem].title : (selectedItem=="movieList") ? movieArray[currentItem].title : (selectedItem=="tvList") ? tvArray[currentItem].name : (selectedItem=="searchList") ?  (searchArray.length > 0) ?searchArray[currentItem].title:"-" : "-"
            color:"white"
            opacity:1
            antialiasing:true
            font.pointSize:36
        }

        Image {
            id:playButton
            source:"play.png"
            anchors.centerIn:parent
            antialiasing:true
            width:128
            height:128

            MouseArea {
                //id:ma
                anchors.fill: parent
                hoverEnabled:true
                cursorShape:  Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton
                onEntered: playIconOverlay.color="#55aaff"
                onExited: playIconOverlay.color=Theme.textColor
                onClicked:{
                    (selectedItem=="randomList") ? Qt.openUrlExternally(movieDir+randomArray[currentItem].link) : (selectedItem=="movieList") ? Qt.openUrlExternally(movieDir+movieArray[currentItem].link) : (selectedItem=="tvList") ? Qt.openUrlExternally(movieDir+tvArray[currentItem].link) : (selectedItem=="searchList") ?  (searchArray.length > 0) ? Qt.openUrlExternally(movieDir+searchArray[currentItem].link) : Qt.openUrlExternally("https://moviesjoyhd.to/home") :  Qt.openUrlExternally("https://moviesjoy.is/home")
                    mediaInfoPopup.close();
                }
            }

            ColorOverlay {
                id:playIconOverlay
                anchors.fill: playButton
                source: playButton
                color: Theme.textColor
            }
        }

        Text {
            id:hiddenSummary
            anchors.bottom:parent.bottom
            anchors.left:parent.left
            text:(selectedItem=="randomList") ? randomArray[currentItem].overview : (selectedItem=="movieList") ? movieArray[currentItem].overview : (selectedItem=="tvList") ? tvArray[currentItem].overview : (selectedItem=="searchList") ?  (searchArray.length > 0) ?searchArray[currentItem].overview:"No Results" : "No Results"
            color:"white"
            antialiasing:true
            font.pointSize:16
            bottomPadding:10
            leftPadding:10
            rightPadding:10
            width:parent.width*.90
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            visible:false
        }

        Rectangle {
            id:summaryBox
            anchors.bottom:parent.bottom
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.bottomMargin:70
            color:"black"
            width:parent.width*.95
            height:hiddenSummary.height*1.25
            radius:12
            opacity:.65
        }

            Text {
                id:summary
                anchors.centerIn:summaryBox
                text:(selectedItem=="randomList") ? randomArray[currentItem].overview : (selectedItem=="movieList") ? movieArray[currentItem].overview : (selectedItem=="tvList") ? tvArray[currentItem].overview : (selectedItem=="searchList") ?  (searchArray.length > 0) ?searchArray[currentItem].overview:"No Results" : "No Results"
                color:"white"
                antialiasing:true
                font.pointSize:16
                //anchors.margins:10
                leftPadding:10
                rightPadding:10
                width:parent.width*.95
                elide: Text.ElideRight
                wrapMode: Text.Wrap
            }

        Row {
            anchors.bottom:parent.bottom
            anchors.right:parent.right
            anchors.bottomMargin:10
            anchors.rightMargin:40
            spacing:20
            width:120
            Rectangle {
                width:64
                height:24
                color:"black"
                radius:8
                border.color:"gray"
                border.width:.5
                antialiasing:true

                Text {
                    anchors.centerIn:parent
                    text:(selectedItem=="randomList") ? "⏳ "+randomArray[currentItem].runtime : (selectedItem=="movieList") ? "⏳ "+movieArray[currentItem].runtime : (selectedItem==="searchList") ?  (searchArray.length > 0) ? "⏳ "+searchArray[currentItem].runtime:"-":"-"
                    color:"white"
                    opacity:1
                    font.pointSize:11
                    antialiasing:true
                }
            }

            Rectangle {
                width:68
                height:24
                color:"black"
                radius:8
                border.color:"gray"
                border.width:.5
                antialiasing:true

                Text {
                    anchors.centerIn:parent
                    text:(selectedItem=="randomList") ? "🗓️  "+new Date(randomArray[currentItem].release_date).getFullYear() : (selectedItem=="movieList") ? "🗓️  "+new Date(movieArray[currentItem].release_date).getFullYear() : (selectedItem=="searchList") ?  (searchArray.length > 0) ? "🗓️  "+new Date(searchArray[currentItem].release_date).getFullYear() : "-" : "-"
                    color:"white"
                    opacity:1
                    font.pointSize:11
                    antialiasing:true
                }
            }
        }

        Rectangle {
            id:trailerButton
            anchors.top:parent.top
            anchors.left:parent.left
            anchors.margins:10
            width:84
            height:24
            radius:8
            color:"black"
            border.color:"gray"
            border.width:.5
            antialiasing:true

            Text {
                anchors.centerIn:parent
                text:"🍿 Trailer"
                color:"white"
                font.pointSize:12
                antialiasing:true
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled:true
                cursorShape:  Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton
                onEntered: trailerButton.border.color="#55aaff"
                onExited: trailerButton.border.color="gray"
                onClicked:{
                    summary.visible=false
                    mplayer.source=(selectedItem=="randomList") ? "/home/data/Movies/Trailers/"+randomArray[currentItem].trailer : (selectedItem=="movieList") ? "/home/data/Movies/Trailers/"+movieArray[currentItem].trailer : (selectedItem=="searchList") ?  (searchArray.length > 0) ? "/home/data/Movies/Trailers/"+searchArray[currentItem].trailer:"-":"-"
                    overlayRect.visible=true;
                    mplayer.play();
                }
            }
        }

        Rectangle {
            anchors.top:parent.top
            anchors.right:parent.right
            anchors.margins:10
            width:64
            height:24
            radius:8
            color:"black"
            border.color:"gray"
            border.width:.5
            antialiasing:true

            Text {
                anchors.centerIn:parent
                property var n1:(selectedItem=="randomList") ? parseFloat(randomArray[currentItem].rating).toFixed(1).toString() : (selectedItem=="movieList") ? parseFloat(movieArray[currentItem].rating).toFixed(1).toString() : (selectedItem=="searchList") ?  (searchArray.length > 0) ? parseFloat(searchArray[currentItem].rating).toFixed(1).toString():"-":"-"
                text:"⭐ "+n1
                color:"white"
                font.pointSize:10
                antialiasing:true
            }
        }

    Rectangle{
        id:overlayRect
        color:"black"
        width:parent.width
        height:parent.height
        radius:8
        visible:false
    }

        MediaPlayer {
            id: mplayer
            autoPlay: false
            muted: false
            loops:0
            playbackRate:1
            source:""

            onStopped: {
                overlayRect.visible=false;
                summary.visible=true
                mplayer.stop();
                mplayer.source=""
            }
        }

        VideoOutput {
            id: voutput
            fillMode: VideoOutput.PreserveAspectFit
            anchors.fill: parent
            source: mplayer
            smooth:true
        }
    }
}
