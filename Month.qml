import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    id:mother
    property date currentDate : new Date()

    header: Label {
        text: mother.currentDate.toLocaleString(Qt.locale("en_US"),"yyyy")
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }

    ListModel{
        id:monthmodel
        ListElement{
            month:"1"
            balance:0
        }
    }

    Timer{
        interval: 1
        repeat: false
        running: true
        onTriggered: {
            monthmodel.clear();
            var themonthdate = mother.currentDate;
            for(var i = 0;i<12;i++){
                themonthdate.setMonth(i);
                monthmodel.append({month:themonthdate.toLocaleString(Qt.locale("en_US"),"MMMM"),balance:themonthdate.getMonth()+1});
            }
            monthlistview.currentIndex = mother.currentDate.getMonth()
        }
    }

    ListView{
        id: monthlistview
        model: monthmodel
        anchors.fill: parent
        clip: true
        delegate: ItemDelegate{
            width: parent.width
            text: model.month+' > '+model.balance
        }
    }
}
