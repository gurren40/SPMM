import QtQuick 2.12
import QtQuick.Controls 2.5
import "./view"

ApplicationWindow {
    id:window
    visible: true
    width: 480
    height: 800
    title: qsTr("Money Manager")

    StackView{
        id:stackView
        anchors.fill: parent
        initialItem: "qrc:/qml/view/Core.qml"
    }
}
