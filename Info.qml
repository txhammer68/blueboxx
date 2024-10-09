import QtQuick 2.9
import QtQuick.Controls 2.5 as QC25
import org.kde.plasma.components 2.0
import org.kde.plasma.core 2.1
import QtMultimedia 5.9
import QtGraphicalEffects 1.5

QC25.Popup {
    anchors.centerIn: parent
    width: 1600
    height: 900
    modal: true
    focus: true
    //dim:false

    //closePolicy: mediaInfoPopup.CloseOnEscape || mediaInfoPopup.CloseOnPressOutsideParent || mediaInfoPopup.CloseOnPressOutside

    onClosed: {
        mplayer.stop();
        mplayer.source="";
        bkBlur.opacity=0;
        overlayRect.visible=false;
        playIconOverlay.color="white"
        playButton.visible=true;
        trailerButton.visible=true;
        summary.visible=true;
        scrollView.focus=true;
        listView.focus=true;
        voutput.opacity=-1;
        currentItem=-1;
        contentChildren=[];
        contentData=[];
        listView.focus=true;
    }

    onOpened:{
         Qt.cursorShape=Qt.ArrowCursor;
         bkBlur.opacity=1
         playIconOverlay.color="white"
    }


    QC25.Overlay.modal: GaussianBlur {
        source: ShaderEffectSource {
            id:bkBlur
            sourceItem: bluebox
            live: false
        }
        radius: 24
        samples: radius * 2
        opacity:0
        smooth:true
        Behavior on opacity { NumberAnimation { duration: 300 } }
    }

    enter: Transition {
        NumberAnimation {
            property: "scale";
            from: 0.6;
            to: 1.0;
            easing.type: Easing.OutBack
            duration: 600
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "scale";
            from: 1.0
            to: 0.6;
            easing.type: Easing.InBack
            duration: 400
        }
    }

    background: Rectangle {
        id:backgroundRect
        antialiasing:true
        smooth:true
        color:"transparent"
        radius:8

        Image{
            id:backdropImg
            source:scripts.selectSource ("backdrop")
            anchors.fill:parent
            //width:parent.width*.996
            //height:parent.height*.996
            fillMode : Image.PreserveAspectCrop
            opacity:1
            //smooth: true
            //antialiasing: true
            mipmap: true
            visible:false
        }

        OpacityMask {
                anchors.fill: backdropImg
                source: backdropImg
                maskSource: Rectangle {
                    width: backdropImg.width
                    height: backdropImg.height
                    radius: 10
                    antialiasing:true
                    smooth:true
                    visible: false // this also needs to be invisible or it will cover up the image
                }
            }

        Text {
            id:titleHeaderHidden
            anchors.top:parent.top
            anchors.left:parent.left
            text:scripts.selectSource ("title")
            color:"white"
            visible:false
            antialiasing:true
            leftPadding:30
            rightPadding:30
            topPadding:5
            bottomPadding:5
            font.pointSize:36
        }

        Rectangle {
            id:titleBox
            anchors.top:parent.top
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.topMargin:20
            width:titleHeaderHidden.width//+(titleHeaderHidden.width/2.25)
            height:titleHeaderHidden.height
            color:"black"
            opacity:.65
            radius:8
            antialiasing:true
            smooth:true
        }

        Text {
            id:titleHeader
            anchors.centerIn:titleBox
            //anchors.margins:50
            text:scripts.selectSource ("title")
            color:"white"
            opacity:1
            antialiasing:true
            font.pointSize:36
        }

        Image {
            id:playButton
            source:"play-button.png"
            anchors.centerIn:parent
            antialiasing:true
            smooth:true
            mipmap:true
            sourceSize.width:128
            sourceSize.height:128

            MouseArea {
                //id:ma
                anchors.fill: parent
                hoverEnabled:true
                cursorShape:  Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton
                onEntered:playIconOverlay.color=highLightColor
                onExited: playIconOverlay.color="white"
                onClicked:{
                    scripts.selectSource ("media");
                    tf.text="";
                    tf.focus=false;
                    mediaInfoPopup.close();
                }
            }

            ColorOverlay {
                id:playIconOverlay
                anchors.fill: playButton
                source: playButton
                color: "white"
                smooth:true
            }
        }

        Text {
            id:hiddenSummary
            anchors.bottom:parent.bottom
            anchors.left:parent.left
            text:scripts.selectSource ("summary")
            color:"white"
            antialiasing:true
            font.pointSize:16
            bottomPadding:10
            topPadding:10
            leftPadding:15
            rightPadding:10
            width:parent.width*.95
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
            height:hiddenSummary.height
            radius:8
            opacity:.65
            antialiasing:true
            smooth:true
        }

            Text {
                id:summary
                anchors.centerIn:summaryBox
                text:scripts.selectSource ("summary")
                color:"white"
                antialiasing:true
                font.pointSize:16
                leftPadding:15
                rightPadding:10
                width:parent.width*.95
                elide: Text.ElideRight
                wrapMode: Text.Wrap
            }

            Text {
                   id:hiddenGenre
                    anchors.centerIn:parent
                    visible:false
                    text:scripts.selectSource ("genre")
                    color:"white"
                    font.pointSize:11
                    antialiasing:true
                }

          Rectangle {
                id:genre
                width:hiddenGenre.width+15
                height:24
                anchors.left:parent.left
                anchors.bottom:parent.bottom
                anchors.bottomMargin:10
                anchors.leftMargin:40
                color:Qt.rgba(0,0,0,.65)
                radius:6
                border.color:"gray"
                border.width:.5
                antialiasing:true
                smooth:true

                Text {
                    anchors.centerIn:parent
                    text:scripts.selectSource ("genre")
                    color:Qt.rgba(1,1,1,1)
                    font.pointSize:11
                    antialiasing:true
                }
            }

        Rectangle {
            id:rating
            anchors.bottom:genre.bottom
            anchors.left:genre.right
            anchors.leftMargin:20
            width:64
            height:24
            radius:6
            color:Qt.rgba(0,0,0,.65)
            border.color:"gray"
            border.width:.5
            antialiasing:true
            smooth:true

            Text {
                anchors.centerIn:parent
                text:scripts.selectSource ("rating")
                color:Qt.rgba(1,1,1,1)
                font.pointSize:10
                antialiasing:true
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled:true
                cursorShape:  Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton
                onEntered: parent.border.color="#55aaff"
                onExited: parent.border.color="gray"
                onClicked:Qt.openUrlExternally("https://www.themoviedb.org/movie/"+scripts.selectSource ("id"))
            }
        }

        Rectangle {
            id:trailerButton
            anchors.bottom:rating.bottom
            anchors.left:rating.right
            anchors.leftMargin:20
            width:84
            height:24
            radius:6
            ///color:"black"
            color:Qt.rgba(0,0,0,.65)
            border.color:"gray"
            border.width:.5
            antialiasing:true
            smooth:true

            Text {
                anchors.centerIn:parent
                text:"🍿 Trailer"
                //color:"white"
                color:Qt.rgba(1,1,1,1)
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
                    summary.visible=false;
                    Qt.cursorShape=Qt.BlankCursor;
                    mplayer.source=scripts.selectSource ("trailer");
                    //playButton.visible=false;
                    overlayRect.visible=true;
                    //trailerButton.visible=false;
                    voutput.opacity=0;
                    voutput.opacity=1;
                    mplayer.play();
                }
            }
        }

        Row {
            anchors.bottom:parent.bottom
            anchors.right:summaryBox.right
            anchors.bottomMargin:10
            anchors.rightMargin:15
            spacing:20
            width:140
            Rectangle {
                width:64
                height:24
                color:Qt.rgba(0,0,0,.65)
                radius:6
                border.color:"gray"
                border.width:.5
                antialiasing:true
                smooth:true

                Text {
                    anchors.centerIn:parent
                    text:scripts.selectSource ("runtime")
                    color:Qt.rgba(1,1,1,1)
                    opacity:1
                    font.pointSize:11
                    antialiasing:true
                }
            }

            Rectangle {
                width:68
                height:24
                color:Qt.rgba(0,0,0,.65)
                radius:6
                border.color:"gray"
                border.width:.5
                antialiasing:true
                smooth:true

                Text {
                    anchors.centerIn:parent
                    text:scripts.selectSource ("date")
                    color:Qt.rgba(1,1,1,1)
                    font.pointSize:11
                    antialiasing:true
                }
            }
        }

    Rectangle{
        id:overlayRect
        color:"black"
        width:parent.width
        height:parent.height
        radius:8
        visible:false
        antialiasing:true
        smooth:true
    }

        MediaPlayer {
            id: mplayer
            autoPlay: false
            muted: false
            loops:0
            playbackRate:1
            source:""
            notifyInterval:500
            onStopped: {
                 mplayer.source="";
                 Qt.cursorShape=Qt.BlankCursor;
                 playButton.opacity=1;
                 trailerButton.visible=true;
                 summary.visible=true;
                 overlayRect.visible=false;
                 voutput.opacity=0;
                 voutput.focus=false;
                 parent.focus=true;
                 listView.focus=true;
            }
            onPlaying:{
                 //playButton.visible=false;
                 //railerButton.visible=false;
                 //summary.visible=false;
                 overlayRect.visible=true;
                 voutput.opacity=1;
                 voutput.focus=true;
                 //parent.focus=false;
            }
        }

        VideoOutput {
            id: voutput
            fillMode: VideoOutput.PreserveAspectFit
            anchors.fill: parent
            source: mplayer
            smooth:true
            visible:true
            opacity:0
            Behavior on opacity {
                    OpacityAnimator {
                        duration:1500
                        easing.type: Easing.InCubic
                    }}
             Keys.onSpacePressed: {
                 mplayer.stop();
                 mplayer.source="";
                 playButton.opacity=1;
                 trailerButton.visible=true;
                 summary.visible=true;
                 overlayRect.visible=false;
                 voutput.opacity=0;
                 voutput.focus=false;
                 parent.focus=true;
                 listView.focus=true;
             }
             Keys.onEscapePressed: {
                 mplayer.stop();
                 mplayer.source="";
                 playButton.opacity=1;
                 trailerButton.visible=true;
                 summary.visible=true;
                 overlayRect.visible=false;
                 voutput.opacity=0;
                 voutput.focus=false;
                 parent.focus=true;
                 listView.focus=true;
             }
        }
    }
}
