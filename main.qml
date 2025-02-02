import QtQuick 2.9
import QtQuick.Layouts 1.5
import QtQuick.Controls 2.5
import org.kde.plasma.core 2.1

// *********************************************
// *** blueboxx media manager app
// *** https://github.com/txhammer68/blueboxx
// *** 03/2024
// *** json arrays for movie/tv shows info
// *** tmdb api for media info and art work
// *********************************************


ApplicationWindow {
   id:rootMain
   visible: true
   color:Theme.viewBackgroundColor
   width:Screen.width
   height:Screen.height
   title: "BlueBoxx"
   //flags: Qt.WindowStaysOnTopHint

   onClosing: rootMain.destroy();

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
