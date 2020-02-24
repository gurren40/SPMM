import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12

Page {
    id:mother
    property date currentDate : new Date()

    header: ToolBar{
        id : theToolbar
        width: parent.width
        ToolButton{
            text: "Left"
            onClicked: {
                var x = mother.currentDate.getMonth() - 1;
                var y = mother.currentDate;
                y.setMonth(x);
                mother.currentDate = y;
                console.log(mother.currentDate.getMonth());
                dayTimer.running = true;
            }
            anchors.left: parent.left
            padding: 10
        }

        Label {
            text: mother.currentDate.toLocaleString(Qt.locale("en_US"),"MMMM yyyy")
            font.pixelSize: Qt.application.font.pixelSize * 2
            padding: 10
            anchors.horizontalCenter: parent.horizontalCenter
        }

        ToolButton{
            text: "Right"
            onClicked: {
                var x = mother.currentDate.getMonth() + 1;
                var y = mother.currentDate;
                y.setMonth(x);
                mother.currentDate = y;
                console.log(mother.currentDate.getMonth());
                dayTimer.running = true;
            }
            anchors.right: parent.right
            padding: 10
        }
    }

    ListModel{
        id:datemodel
        ListElement{
            date:1
            balance:0
        }
    }

    Timer{
        id:dayTimer
        interval: 1
        repeat: false
        running: true
        onTriggered: {
            datemodel.clear();
            datemodel.append({date:1,balance:1});
            var number = 2;
            var thedate = mother.currentDate;
            while(number != 1){
                thedate.setDate(number);
                datemodel.append({date:thedate.getDate(),balance:thedate.getDate()});
                thedate.setDate(number+1);
                number = thedate.getDate();
                console.log(number);
            }
        }
    }

    ListView{
        model: datemodel
        anchors.fill: parent
        height: parent.height - theToolbar.height
        clip: true
        delegate: ItemDelegate{
            width: parent.width
            text: model.date+' > '+model.balance
        }
    }
}
