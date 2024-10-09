import QtQuick 2.9
import QtQuick.Layouts 1.5
import QtQuick.Controls 2.5 as QC25
import QtQuick.Controls 1.5 as QC15
import org.kde.plasma.components 2.0
import org.kde.plasma.core 2.1
import QtGraphicalEffects 1.5
import QtQuick.Controls.Styles 1.4

QC25.Popup {
    anchors.centerIn: parent
    width: 1600
    height: 900
    modal: true
    focus: true
    //dim:false

    onClosed: {
        Qt.cursorShape=Qt.ArrowCursor;
        //contentChildren=[];
        //contentData=[];
        currentCollectionItem=-1
        listViewCollections.delegate=null
        listViewCollections.model=0
        listViewCollections.opacity=0
        //bkBlur3.opacity=0;
    }

    onOpened: {
        //bkBlur3.opacity=1;
        listViewCollections.delegate=collectionView
        listViewCollections.model=collectionArray.parts.length
        listViewCollections.opacity=1
        listViewCollections.positionViewAtBeginning();
        Qt.cursorShape=Qt.ArrowCursor;
        playIconOverlay.color=Theme.textColor
    }

    QC25.Overlay.modal: GaussianBlur {
        source: ShaderEffectSource {
            id:bkBlur3
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
        color:"transparent"
        radius:8

        Image{
            id:backdropImg
            source:"./backdrops"+collectionArray.backdrop_path
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
                    smooth: true
                    antialiasing: true
                    visible: false // this also needs to be invisible or it will cover up the image
                }
            }

        Text {
            id:titleHeaderHidden
            anchors.top:parent.top
            anchors.left:parent.left
            text:collectionArray.title
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
            width:titleHeaderHidden.width
            height:titleHeaderHidden.height
            color:"black"
            opacity:.65
            radius:12
            smooth: true
            antialiasing: true
        }

        Text {
            id:titleHeader
            anchors.centerIn:titleBox
            //anchors.margins:50
            text:collectionArray.title
            color:"white"
            opacity:1
            antialiasing:true
            font.pointSize:36
        }

        Text {
            id:hiddenSummary
            anchors.bottom:parent.bottom
            anchors.left:parent.left
            text:collectionArray.overview
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
            anchors.bottomMargin:40
            color:"black"
            width:parent.width*.95
            height:hiddenSummary.height
            radius:12
            opacity:.65
            smooth: true
            antialiasing: true
        }

            Text {
                id:summary
                anchors.centerIn:summaryBox
                text:collectionArray.overview
                color:"white"
                antialiasing:true
                font.pointSize:16
                leftPadding:15
                rightPadding:10
                width:parent.width*.95
                elide: Text.ElideRight
                wrapMode: Text.Wrap
            }

        }
Component {
        id:collectionView

        Rectangle { width:185;height:295;
            color:"black";
            border.color:"lightgray"
            border.width:2;
            radius: 4;
            smooth: true
            antialiasing: true

            Image {
                source: "./posters"+collectionArray.parts[index].poster_path
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
                    anchors.topMargin:7
                    anchors.leftMargin:0
                    text:collectionArray.parts[index].title
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
                    currentCollectionItem=-1;
                    currentCollectionItem=index;
                    collectionInfo.open();

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
        QC15.ScrollView {
        id: scrollViewCollections
        anchors.top:titleBox.bottom
        anchors.bottom:parent.bottom
        anchors.left:parent.left
        anchors.right:parent.right
        anchors.topMargin:40
        anchors.leftMargin:5
        anchors.rightMargin:5
        anchors.bottomMargin:1
        width:parent.width
        height:parent.height-titleBox.height
        clip:false
        focus:true
        verticalScrollBarPolicy : Qt.ScrollBarAsNeeded
        enabled : hovered || pressed
        __wheelAreaScrollSpeed: 315
        style: ScrollViewStyle {
        transientScrollBars:true
        scrollToClickedPosition : true
        handle: Rectangle {
            implicitWidth: 8
            //implicitHeight: 400
            color: "white"
            radius:8
            smooth: true
            antialiasing: true
        }
        scrollBarBackground: Rectangle {
            implicitWidth: 8
            //implicitHeight: parent.height
            color: "black"
            radius:8
            opacity:.25
            smooth: true
            antialiasing: true
        }
    }


        GridView {
            id:listViewCollections
            focus:true
            visible:true
            opacity:0
            parent:scrollViewCollections
            anchors.top:parent.top
            anchors.left:parent.left
            anchors.leftMargin:collectionArray.parts.length < 8 ? parent.width/2-(collectionArray.parts.length*cellWidth/2) : 90
            //anchors.leftMargin:collectionArray.parts.length < 6 ? parseInt((listViewCollections.width/2)-(listViewCollections.model*listViewCollections.cellWidth/1.85)) : 90
            anchors.topMargin:collectionArray.parts.length < 8 ? 140 : 40
            width:parent.width*95
            height:parent.height*.95
            model:collectionArray.parts.length
            delegate:collectionView
            cellWidth: 200; cellHeight: 315
            boundsBehavior: Flickable.StopAtBounds
            cacheBuffer:10
            clip:true
            interactive:false
            snapMode :GridView.SnapOneRow
            keyNavigationEnabled: true
            keyNavigationWraps : false
            Keys.onPressed:{
                if(event.key === Qt.Key_PageUp){
                    if (!atYBeginning) {
                    listViewCollections.flick(0, contentY-=630);}
                }
                else if(event.key === Qt.Key_PageDown){
                    if (!atYEnd) {
                       listViewCollections.flick(0, contentY+=630)
                    }
                }
                else if(event.key === Qt.Key_Home){
                    listViewCollections.positionViewAtBeginning()
                }
                else if(event.key === Qt.Key_End){
                    listViewCollections.positionViewAtEnd()
                }
            }
            Keys.onUpPressed: {
                if (!atYBeginning) {
                listViewCollections.flick(0, contentY-=315)
                } }
            Keys.onDownPressed:{
                 if (!atYEnd) {
                listViewCollections.flick(0, contentY+=315)
                 } }
                Behavior on opacity {
                    OpacityAnimator {
                        duration: 250
                        easing.type: Easing.InCubic
                    }}

                    Behavior on contentY{ // smooth scroll animation
                        NumberAnimation {
                            duration: 1000
                            easing.type: Easing.OutQuad
                        }
                    }
        }
    }
}

