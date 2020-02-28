import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12

Page {
    id:mother
    property date currentDate : new Date()

    ItemDelegate{
        anchors.centerIn: parent
        width: parent.width
        text: "Menu are here"
    }
}
