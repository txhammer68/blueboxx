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

    //closePolicy: mediaInfoPopup.CloseOnEscape || mediaInfoPopup.CloseOnPressOutsideParent || mediaInfoPopup.CloseOnPressOutside

    onClosed: {
        mplayer.stop();
        mplayer.source="";
        overlayRect.visible=false;
        playIconOverlay.color=Theme.textColor
        playButton.visible=true;
        trailerButton.visible=true;
        summary.visible=true;
        scrollView.focus=true;
        listView.focus=true;
        voutput.opacity=-1;
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
            duration: 600
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
        id:backgroundRect
        antialiasing:true
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
            smooth: true
            antialiasing: true
            mipmap: true
            visible:false
        }

        OpacityMask {
                anchors.fill: backdropImg
                source: backdropImg
                maskSource: Rectangle {
                    width: backdropImg.width
                    height: backdropImg.height
                    radius: 8
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
            radius:12
            antialiasing:true
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
            source:"play.png"
            anchors.centerIn:parent
            antialiasing:true
            smooth:true
            sourceSize.width:128
            sourceSize.height:128

            MouseArea {
                //id:ma
                anchors.fill: parent
                hoverEnabled:true
                cursorShape:  Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton
                onEntered:playIconOverlay.color="#55aaff"
                onExited: playIconOverlay.color=Theme.textColor
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
                color: Theme.textColor
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
            radius:12
            opacity:.65
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
                width:hiddenGenre.width+15
                height:24
                anchors.left:parent.left
                anchors.bottom:parent.bottom
                anchors.bottomMargin:10
                anchors.leftMargin:40
                color:Qt.rgba(0,0,0,.65)
                radius:8
                border.color:"gray"
                border.width:.5
                antialiasing:true

                Text {
                    anchors.centerIn:parent
                    text:scripts.selectSource ("genre")
                    color:Qt.rgba(1,1,1,1)
                    font.pointSize:11
                    antialiasing:true
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
                radius:8
                border.color:"gray"
                border.width:.5
                antialiasing:true

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
                radius:8
                border.color:"gray"
                border.width:.5
                antialiasing:true

                Text {
                    anchors.centerIn:parent
                    text:scripts.selectSource ("date")
                    color:Qt.rgba(1,1,1,1)
                    font.pointSize:11
                    antialiasing:true
                }
            }
        }

        Rectangle {
            id:trailerButton
            anchors.top:parent.top
            anchors.left:parent.left
            anchors.margins:15
            width:84
            height:24
            radius:8
            ///color:"black"
            color:Qt.rgba(0,0,0,.65)
            border.color:"gray"
            border.width:.5
            antialiasing:true

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
                    mplayer.source=scripts.selectSource ("trailer");
                    playButton.visible=false;
                    overlayRect.visible=true;
                    trailerButton.visible=false;
                    voutput.opacity=0;
                    voutput.opacity=1;
                    mplayer.play();
                }
            }
        }

        Rectangle {
            anchors.top:parent.top
            anchors.right:parent.right
            anchors.margins:15
            width:64
            height:24
            radius:8
            color:Qt.rgba(0,0,0,.65)
            border.color:"gray"
            border.width:.5
            antialiasing:true

            Text {
                anchors.centerIn:parent
                text:scripts.selectSource ("rating")
                color:Qt.rgba(1,1,1,1)
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
                 mplayer.source="";
                 playButton.visible=true;
                 trailerButton.visible=true;
                 summary.visible=true;
                 overlayRect.visible=false;
                 voutput.opacity=0;
                 voutput.focus=false;
                 parent.focus=true;
            }
            onPlaying:{
                 playButton.visible=false;
                 trailerButton.visible=false;
                 Qt.cursorShape=Qt.ArrowCursor;
                 summary.visible=false;
                 overlayRect.visible=true;
                 voutput.opacity=1;
                 voutput.focus=true;
                 parent.focus=false;
            }
        }

        VideoOutput {
            id: voutput
            fillMode: VideoOutput.PreserveAspectFit
            anchors.fill: parent
            source: mplayer
            smooth:true
            opacity:0
            Behavior on opacity {
                    OpacityAnimator {
                        duration:1500
                        easing.type: Easing.InCubic
                    }}
             Keys.onSpacePressed: mplayer.stop();
        }
    }
}
