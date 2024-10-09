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
        contentChildren=[];
        contentData=[];
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
        color:"#00334b"
        radius:8


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
        text:"Add Movie to Library"
        color:"white"
        font.pointSize:16
        antialiasing:true
        anchors.horizontalCenter:parent.horizontalCenter
        anchors.top:parent.top
        anchors.topMargin:200

    QC25.TextField {
        id:tf
        placeholderText:"Movie ID:"
        anchors.top:parent.bottom
        anchors.horizontalCenter:parent.horizontalCenter
        anchors.topMargin:15
        width:180
        height:36
        visible:true
        antialiasing:true
        opacity:.75
        onAccepted: {
            executable.exec("python3 ./tmdb/getMovieInfo.py"+" "+tf.text)
           }
        focus:true
        placeholderTextColor:"gray"

        background: Rectangle {
            width:parent.width
            height:parent.height
            color: "black"
            radius: 8
            border.color: highLightColor
            border.width: 1
            antialiasing:true
            smooth:true
        }
    }

    Text {
        id:fini
        text:"test"
        color:"white"
        font.pointSize:16
        antialiasing:true
        anchors.horizontalCenter:parent.horizontalCenter
        anchors.top:parent.bottom
        anchors.topMargin:200
    }
    }
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
                fini.text=stdout
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
    }
