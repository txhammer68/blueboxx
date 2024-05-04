import QtQuick 2.9
import QtQuick.Controls 2.5 as QC25
import org.kde.plasma.components 2.0
import org.kde.plasma.core 2.1
import QtGraphicalEffects 1.5

QC25.Popup {
    anchors.centerIn: parent
    width: 1400
    height: 900
    modal: true
    focus: true
    //closePolicy: mediaInfoPopup.CloseOnEscape || mediaInfoPopup.CloseOnPressOutsideParent || mediaInfoPopup.CloseOnPressOutside

    property int selSeason:-1
    property int selEpisode:-1

    onClosed: {
        Qt.cursorShape=Qt.ArrowCursor;
        childGroup.checkState=0;
        episodeList.model=0;
        selSeason=-1;
        selEpisode=-1;
        episodeTitle.text="";
        episodeInfo.text="";
        episodeRunTime.text="";
        episodeAirDate.text="";
        playButton.visible=false;
        playIconOverlay.visible=false;
        scrollView.focus=true;
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
        //border.color: "gray"
        //border.width:.5
        antialiasing:true
        color:"transparent"
        radius:8

        Image{
            id:tvBackdropImg
            source:"backdrops"+tvArray[currentItem].backdrop_path
            anchors.centerIn:parent
            width:parent.width
            height:parent.height
            fillMode : Image.PreserveAspectStretch
            smooth: true
            antialiasing: true
            mipmap: true
            visible:false
        }

        OpacityMask {
            anchors.fill: tvBackdropImg
            source: tvBackdropImg
            maskSource: Rectangle {
                width: tvBackdropImg.width
                height: tvBackdropImg.height
                radius: 8
                visible: false // this also needs to be invisible or it will cover up the image
            }
        }

        Rectangle {
            id:titleBox
            anchors.top:parent.top
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.topMargin:20
            color:"black"
            width:hiddentShowTitle.width
            height:hiddentShowTitle.height+10
            radius:12
            opacity:.65
        }

        Text {
            id:showTitle
            anchors.centerIn:titleBox
            text:tvArray[currentItem].name
            color:"white"
            opacity:1
            antialiasing:true
            font.pointSize:36
        }

        Text {
            id:hiddentShowTitle
            anchors.top:parent.top
            anchors.left:parent.left
            leftPadding:30
            rightPadding:30
            topPadding:5
            bottomPadding:5
            text:tvArray[currentItem].name
            color:"white"
            visible:false
            antialiasing:true
            font.pointSize:36
        }

        Item {

            id:seasonSelections
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.top:showTitle.bottom
            anchors.topMargin:30
            width:parent.width*.95

            Rectangle {
                id:seasonBox
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.top:parent.top
                color:"black"
                border.color:"#55aaff"
                border.width:.5
                height:36
                width:seasonsRow.width+36
                opacity:.65
                radius:12
                antialiasing:true
            }

            Row {
                id:seasonsRow
                spacing:20
                anchors.centerIn:seasonBox

                QC25.ButtonGroup {
                    id: childGroup
                    exclusive: true
                    checkState: Qt.Unchecked
                }
                Repeater {
                    model:tvArray[currentItem].seasons.length
                    QC25.CheckBox {
                        checked: false
                        text: tvArray[currentItem].seasons[index].name
                        font.pointSize:12
                        QC25.ButtonGroup.group: childGroup
                        onCheckedChanged:{
                            if (checkState === 2) {
                                selSeason=index
                                episodeList.model=0;
                                episodeList.model=parseInt(tvArray[currentItem].seasons[selSeason].episode_count)
                            }
                            if (checkState === 0) {
                                childGroup.checkState=0
                                episodeTitle.text=""
                                episodeInfo.text=""
                                episodeRunTime.text=""
                                episodeAirDate.text=""
                            }
                        }

                    }
                }
            }
        }

        Rectangle {
            id:episodeBox
            anchors.top:seasonSelections.bottom
            anchors.left:parent.left
            anchors.leftMargin:260
            anchors.topMargin:80
            color:"black"
            width:420
            height:480
            radius:12
            opacity:.65
            visible:childGroup.checkState
            antialiasing:true
        }

        ListView {
            id:episodeList
            anchors.top:episodeBox.top
            anchors.left:episodeBox.left
            anchors.margins:15
            clip:true
            width:episodeBox.width*.95
            height:episodeBox.height*.95
            spacing: 5
            //model: 24
            delegate:
            Text {
                text:tvArray[currentItem].seasons[selSeason].episodes[index].episode_number+" - "+tvArray[currentItem].seasons[selSeason].episodes[index].name
                antialiasing:true
                font.pointSize:14
                color:"white"
                bottomPadding:10
                MouseArea {
                    id: mouseArea1a
                    anchors.fill: parent
                    cursorShape:  Qt.PointingHandCursor
                    hoverEnabled:true
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                    onEntered:parent.border.color="#55aaff"
                    onExited:parent.border.color="transparent"
                    onClicked:{
                        episodeTitle.text=tvArray[currentItem].seasons[selSeason].episodes[index].name
                        episodeInfo.text= tvArray[currentItem].seasons[selSeason].episodes[index].overview
                        episodeRunTime.text="⏳ "+tvArray[currentItem].seasons[selSeason].episodes[index].runtime
                        episodeAirDate.text="🗓️  "+Qt.formatDate(new Date(tvArray[currentItem].seasons[selSeason].episodes[index].airdate),"M/yyyy")
                        selEpisode=index;
                    }
                }
            }
            onModelChanged:{
                opacity=0;
                opacity=1;}
                Behavior on opacity {
                    OpacityAnimator {
                        duration:300
                        easing.type: Easing.InCubic
                    }}
        }

        Rectangle {
            id:episodeInfoBox
            anchors.top:episodeBox.top
            anchors.left:episodeBox.right
            anchors.leftMargin:60
            //anchors.topMargin:60
            color:"black"
            width:420
            height:480
            radius:12
            opacity:.65
            visible:episodeTitle.text
            antialiasing:true
        }


        Text {
            id:episodeTitle
            anchors.top:episodeInfoBox.top
            anchors.left:episodeInfoBox.left
            //anchors.horizontalCenter:episodeInfoBox.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            topPadding:20
            leftPadding:15
            ///leftPadding:10
            //rightPadding:5
            color:"white"
            antialiasing:true
            font.bold:true
            font.pointSize:14
            width:episodeInfoBox.width*.95
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
        }

        Text {
            id:episodeInfo
            anchors.top:episodeTitle.bottom
            anchors.left:episodeInfoBox.left
            leftPadding:15
            topPadding:20
            color:"white"
            antialiasing:true
            font.pointSize:14
            width:episodeInfoBox.width*.95
            bottomPadding:20
            height:episodeInfoBox.height*.85
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            MouseArea {
                id: mouseArea1a
                anchors.fill: episodeInfo
                cursorShape:  episodeInfo.text ? Qt.PointingHandCursor : Qt.cursorShape=Qt.ArrowCursor
                hoverEnabled:episodeInfo.text ? true:false
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                onEntered:{
                    episodeInfo.text ? playButton.visible=true : playButton.visible=true
                    episodeInfo.text ? playIconOverlay.visible=true : playButton.visible=false
                }
                onExited:{
                    playButton.visible=false
                    playIconOverlay.visible=false
                }
                onClicked:{
                    Qt.openUrlExternally(tvDir+tvArray[currentItem].name+"/"+tvArray[currentItem].seasons[selSeason].episodes[selEpisode].link)
                }
            }
            onTextChanged:{
                opacity=0;
                opacity=1;}
                Behavior on opacity {
                    OpacityAnimator {
                        duration:300
                        easing.type: Easing.InCubic
                    }}
        }
        Row {
            id:episodeFooter
            anchors.bottom:episodeInfoBox.bottom
            anchors.horizontalCenter:episodeInfoBox.horizontalCenter
            anchors.bottomMargin:10
            spacing:20
            Rectangle {
                width:64
                height:24
                color:"black"
                radius:8
                border.color:"gray"
                border.width:.5
                antialiasing:true
                visible:episodeRunTime.text

                Text {
                    id:episodeRunTime
                    anchors.centerIn:parent
                    color:"white"
                    opacity:1
                    font.pointSize:11
                    antialiasing:true
                }
            }

            Rectangle {
                width:84
                height:24
                color:"black"
                radius:8
                border.color:"gray"
                border.width:.5
                antialiasing:true
                visible:episodeAirDate.text

                Text {
                    id:episodeAirDate
                    anchors.centerIn:parent
                    color:"white"
                    opacity:1
                    font.pointSize:11
                    antialiasing:true
                }
            }
        }

        Image {
            id:playButton
            source:"play.png"
            anchors.centerIn:episodeInfoBox
            antialiasing:true
            smooth:true
            sourceSize.width:64
            sourceSize.height:64
            visible:false
        }

        ColorOverlay {
            id:playIconOverlay
            anchors.fill: playButton
            source: playButton
            color: "#55aaff"
            visible:false
        }

        Text {
            id:hiddenSummary
            anchors.bottom:parent.bottom
            anchors.left:parent.left
            text:tvArray[currentItem].overview
            color:"white"
            antialiasing:true
            font.pointSize:16
            bottomPadding:10
            width:parent.width*.90
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            visible:false
        }

        Rectangle {
            id:summaryBox
            anchors.bottom:parent.bottom
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.bottomMargin:50
            color:"black"
            width:parent.width*.95
            height:hiddenSummary.height*1.25
            radius:12
            opacity:.65
            antialiasing:true

            Text {
                id:summary
                anchors.top:parent.top
                anchors.left:parent.left
                text:tvArray[currentItem].overview
                color:"white"
                antialiasing:true
                font.pointSize:16
                anchors.margins:10
                width:parent.width*.95
                bottomPadding:10
                elide: Text.ElideRight
                wrapMode: Text.Wrap
            }
        }

        Rectangle {
            id:genreBox
            anchors.top:summaryBox.bottom
            anchors.left:summaryBox.left
            anchors.topMargin:10
            width:episodeGenre.width+10
            height:28
            color:"black"
            radius:8
            opacity:.65
            border.color:"gray"
            border.width:.5
            antialiasing:true
        }


        Text {
            id:episodeGenre
            anchors.centerIn:genreBox
            color:"white"
            text:"🎭 "+tvGenres
            font.pointSize:11
            antialiasing:true
        }
    }
}
