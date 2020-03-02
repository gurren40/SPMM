import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12

Page {
    id:mother
    anchors.fill: parent
    property date currentDate : new Date()

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        DayList {
        }

        MonthList {
        }

        YearList {
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
