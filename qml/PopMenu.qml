import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4


//Rectangle {
//    id: background
//    color:"#00000000"
//    width:100
//    height:100
Menu {
    id:menu
     title: "test"
//     style: MenuStyle {
//         frame: parent
//     }


    MenuItem {
        text: "menu1"
       // shortcut: "Ctrl+X"

        onTriggered: {}
    }

    MenuItem {
        text: "menu2"
      //  shortcut: "Ctrl+C"
        onTriggered: {}
    }
}
//}
