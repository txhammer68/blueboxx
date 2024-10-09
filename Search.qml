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

    property string searchTerms:''
    property string tempString:''
    property string searchYear:''
    property string tempYear:''
    readonly property var genreList:['Action','Adventure','Animation','Comedy','Crime','Documentary','Drama','Family','Fantasy','History','Horror','Martial Arts','Music','Mystery','Romance','Science Fiction','TV Movie','Thriller','War','Western']
    readonly property var yearList:["1950","1960","1970","1980","1990","2000","2010","2020"]

    onClosed: {
        childGroup.checkState=0;
        childGroup2.checkState=0;
        searchTerms='';
        tempString='';
        searchYear='';
        Qt.cursorShape=Qt.ArrowCursor;
        scrollView.focus=true
        bkBlur.opacity=0;
    }

     onOpened:{
         Qt.cursorShape=Qt.ArrowCursor;
         bkBlur.opacity=1
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

    background:Rectangle{
        color:"#001d2a"
        radius:8
        antialiasing:true
        smooth:true



        Text {
            id:title
            anchors.top:parent.top
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.topMargin:60
            text:"Advanced Search"
            antialiasing:true
            color:"white"
            font.pointSize:24
        }

        Rectangle {
            id:ts1
            anchors.top:title.bottom
            anchors.horizontalCenter:title.horizontalCenter
            anchors.topMargin:30
            width:parent.width*.90
            height:1
            color:"white"
            opacity:.25
            antialiasing:true
            smooth:true
        }

        Text {
            id:genresSearch
            anchors.top:ts1.bottom
            anchors.horizontalCenter:title.horizontalCenter
            anchors.topMargin:90
            text:"Search by Genre"
            color:"white"
            font.pointSize:18
            antialiasing:true
        }


        Rectangle {
            id:genreSelections
            width:parent.width*.90
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.top:genresSearch.bottom
            anchors.topMargin:20
            height:28
            color:"black"
            opacity:.45
            radius:8
        }

            Row {
                anchors.horizontalCenter:genreSelections.horizontalCenter
                anchors.top:genreSelections.top
                spacing:20

                QC25.ButtonGroup {
                    id: childGroup
                    exclusive: false
                    checkState: Qt.Unchecked
                }

                Repeater {
                    model:10

                    QC25.CheckBox {
                        checked: false
                        text: genreList[index]
                        font.pointSize:14
                        QC25.ButtonGroup.group: childGroup
                        onCheckedChanged:{
                            if (checkState === 2) {
                                tempString=tempString.concat(genreList[index],",")
                                searchTerms=tempString.replace(/,\s*$/, "").replace(/^,/, '')
                            }
                            if (checkState === 0) {
                                tempString=tempString.replace(genreList[index],"").replace(/,\s*$/, "")
                                searchTerms=tempString.replace(/,\s*$/, "").replace(/^,/, '')
                            }
                        }
                    }
                }
            }

        Rectangle {
            id:genreSelections2
            width:parent.width*.90
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.top:genreSelections.bottom
            anchors.topMargin:40
            height:28
            color:"black"
            opacity:.45
            radius:8
        }

        Row {
            anchors.horizontalCenter:genreSelections2.horizontalCenter
            anchors.top:genreSelections2.top
            spacing:20

            Repeater {
                model:10

                QC25.CheckBox {
                    checked: false
                    text: genreList[index+10]
                    font.pointSize:14
                    QC25.ButtonGroup.group: childGroup
                    onCheckedChanged:{
                        if (checkState === 2) {
                            tempString=tempString.concat(genreList[index+10],",")
                            searchTerms=tempString.replace(/,\s*$/, "").replace(/^,/, '')
                        }
                        if (checkState === 0) {
                            tempString=tempString.replace(genreList[index+10],"").replace(/,\s*$/, "")
                            searchTerms=tempString.replace(/,\s*$/, "").replace(/^,/, '')
                        }
                    }
                }
            }
        }

        Row {
            id:searchButtons
            spacing:20
            anchors.horizontalCenter:title.horizontalCenter
            anchors.top:genreSelections2.bottom
            anchors.topMargin:50

            Rectangle {
                width:72
                height:32
                radius:8
                color:"transparent"
                border.color:"gray"
                antialiasing:true

                Text {
                    anchors.centerIn:parent
                    text:"Search"
                    color:"white"
                    font.bold:true
                    font.pointSize:12
                    antialiasing:true
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape:  Qt.PointingHandCursor
                    hoverEnabled:true
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                    onEntered:parent.color=highLightColor
                    onExited:parent.color="transparent"
                    onClicked: {
                        tf.text=""
                        tf.focus=false
                        searchPopup.close();
                        selectedItem="searchList"
                        scripts.genreSearch (searchTerms);
                        scripts.selectedViewChanged ();
                    }
                }
            }

            Rectangle {
                width:72
                height:32
                radius:8
                color:"transparent"
                border.color:"gray"
                antialiasing:true
                smooth:true

                Text {
                    anchors.centerIn:parent
                    text:"Reset"
                    color:"white"
                    font.bold:true
                    font.pointSize:12
                    antialiasing:true
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape:  Qt.PointingHandCursor
                    hoverEnabled:true
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                    onEntered:parent.color=highLightColor
                    onExited:parent.color="transparent"
                    onClicked:{
                        childGroup.checkState=0;
                        tempString='';
                        searchTerms='';
                    }
                }
            }
        }

        Rectangle {
            id:ts2
            anchors.top:searchButtons.bottom
            anchors.horizontalCenter:title.horizontalCenter
            anchors.topMargin:40
            width:parent.width*.90
            height:1
            color:"white"
            opacity:.25
            antialiasing:true
            smooth:true
        }

        Text {
            id:yearTitle
            anchors.top:searchButtons.bottom
            anchors.horizontalCenter:title.horizontalCenter
            anchors.topMargin:70
            text: "Search by Year"
            color:"white"
            font.pointSize:20
            antialiasing:true
        }

        Rectangle {
            id:yearSelections
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.top:yearTitle.bottom
            anchors.topMargin:20
            width:parent.width*.90
            height:28
            color:"black"
            opacity:.45
            radius:8
            antialiasing:true
            smooth:true
        }

        Row {
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.top:yearSelections.top
            spacing:20

            QC25.ButtonGroup {
                id: childGroup2
                exclusive: true
                checkState: Qt.Unchecked
            }

            Repeater {
                model:8

                QC25.CheckBox {
                    checked: false
                    text: yearList[index]+"'s"
                    font.pointSize:14
                    QC25.ButtonGroup.group: childGroup2
                    onCheckedChanged:{
                        if (checkState === 2) {
                            searchYear=yearList[index]
                        }
                        if (checkState === 0) {
                            tempYear=''
                        }
                    }
                }
            }
        }

        Row {
            id:searchButtons2
            spacing:20
            anchors.horizontalCenter:title.horizontalCenter
            anchors.top:yearSelections.bottom
            anchors.topMargin:40

            Rectangle {
                width:72
                height:32
                radius:8
                color:"transparent"
                border.color:"gray"
                antialiasing:true
                smooth:true

                Text {
                    anchors.centerIn:parent
                    text:"Search"
                    color:"white"
                    font.bold:true
                    antialiasing:true
                    font.pointSize:12
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape:  Qt.PointingHandCursor
                    hoverEnabled:true
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                    onEntered:parent.color=highLightColor
                    onExited:parent.color="transparent"
                    onClicked:{
                        tf.text=""
                        tf.focus=false
                        searchPopup.close();
                        selectedItem="searchList"
                        scripts.yearSearch (searchYear);
                        scripts.selectedViewChanged ();
                    }
                }
            }

            Rectangle {
                width:72
                height:32
                radius:8
                color:"transparent"
                border.color:"gray"
                antialiasing:true
                smooth:true

                Text {
                    anchors.centerIn:parent
                    text:"Reset"
                    color:"white"
                    font.bold:true
                    font.pointSize:12
                    antialiasing:true
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape:  Qt.PointingHandCursor
                    hoverEnabled:true
                    onEntered:parent.color=highLightColor
                    onExited:parent.color="transparent"
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                    onClicked:{
                        childGroup2.checkState=0;
                        searchYear='';
                    }
                }
            }
        }
    }
}
