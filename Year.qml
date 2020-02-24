import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    id:mother
    property date currentDate : new Date()

    header: Label {
        text: qsTr("Year")
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }

    ListModel{
        id:yearmodel
        ListElement{
            year:2010
            balance:0
        }
    }

    Timer{
        interval: 1
        repeat: false
        running: true
        onTriggered: {
            yearmodel.clear();
            var theyeardate = mother.currentDate;
            for(var i = 2010;i<=mother.currentDate.getFullYear();i++){
                theyeardate.setFullYear(i);
                yearmodel.append({year:theyeardate.getFullYear(),balance:theyeardate.getFullYear()});
            }
        }
    }

    ListView{
        id: yearlistview
        model: yearmodel
        anchors.fill: parent
        clip: true
        delegate: ItemDelegate{
            width: parent.width
            text: model.year+' > '+model.balance
        }
    }
}
