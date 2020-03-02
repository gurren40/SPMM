import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.3
import "../create"

Page {
    id:mother
    property date currentDate : new Date()

    ColumnLayout{
        anchors.fill: parent
        spacing: 40
        ScrollView{
            Layout.fillHeight: true
            Layout.fillWidth: true
            contentWidth: width
            Column{
                width: parent.width
                ItemDelegate{
                    width: parent.width
                    text: "View Categories"
                    icon.name: "chevron_right"
                    onClicked: stackView.push("qrc:/qml/view/CategoryList.qml")
                }
                ItemDelegate{
                    width: parent.width
                    text: "Add New Category"
                    icon.name: "plus"
                    onClicked: stackView.push("qrc:/qml/create/CreateKategori.qml")
                }
            }
        }
    }
}
