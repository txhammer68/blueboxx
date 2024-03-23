import QtQuick 2.9
import QtQuick.Layouts 1.5
import QtQuick.Controls 2.5
import org.kde.plasma.core 2.1

// media manager app v2.2
// txhammer
// 03/2024
// added popup window for media info and search options, various performance fixes
// *********************************************************************************************************

ApplicationWindow {
   id:rootMain
   visible: true
   color:"black"
   width:Screen.width
   height:Screen.height
   title: "BlueBoxx"
   //flags: Qt.WindowStaysOnTopHint

   Shortcut {
      sequence: "Esc"
      onActivated: rootMain.close()
   }

    BlueBoxx {
       id:bluebox
       anchors.fill: parent
       opacity: 1
       visible:true
       focus: true
       //onVisibleChanged:{
       //  opacity = 1
      //}
   }
    Component.onCompleted:{
       rootMain.showFullScreen();
       //bluebox.visible=true
    }
}
