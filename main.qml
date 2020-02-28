import QtQuick 2.12
import QtQuick.Controls 2.5

ApplicationWindow {
    id:window
    visible: true
    width: 480
    height: 800
    title: qsTr("Money Manager")

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Day {
        }

        Month {
        }

        Year {
        }

        OtherMenu{
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {
            text: qsTr("Day")
        }
        TabButton {
            text: qsTr("Month")
        }
        TabButton {
            text: qsTr("Year")
        }
        TabButton {
            icon.name:"menu"
        }
    }
}
