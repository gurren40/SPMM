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
            icon.name: "chevron_left"
            onClicked: {
                var x = mother.currentDate.getDate() - 1;
                var y = mother.currentDate;
                y.setDate(x);
                mother.currentDate = y;
                console.log(mother.currentDate.getDate());
                dayTimer.running = true;
            }
            anchors.left: parent.left
            padding: 10
        }

        Label {
            text: mother.currentDate.toLocaleString(Qt.locale("en_US"),"dd MMMM yyyy")
            font.pixelSize: Qt.application.font.pixelSize * 2
            padding: 10
            anchors.horizontalCenter: parent.horizontalCenter
        }

        ToolButton{
            icon.name: "chevron_right"
            onClicked: {
                var x = mother.currentDate.getDate() + 1;
                var y = mother.currentDate;
                y.setDate(x);
                mother.currentDate = y;
                console.log(mother.currentDate.getDate());
                dayTimer.running = true;
            }
            anchors.right: parent.right
            padding: 10
        }
    }

    ListModel{
        id:datemodel
        ListElement{
            iconname:"power"
            notes:"1"
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
            datemodel.append({iconname:"sun",balance:0,notes:"Matahari"});
            var number = 2;
            var thedate = mother.currentDate;
            while(number != 1){
                thedate.setDate(number);
                datemodel.append({iconname:"lamp",balance:thedate.getDate(),notes:"Listrik"});
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
        delegate: Row{
            width: parent.width
            ItemDelegate{
                id:notbalance
                width: parent.width - balance.width
                text: model.notes
                icon.name : model.iconname
                hoverEnabled: false
                onClicked: onClickedAction()
                function onClickedAction(){
                    console.log("clicked")
                }
            }
            ItemDelegate{
                id:balance
                hoverEnabled: false
                anchors.verticalCenter: notbalance.verticalCenter
                text: "Rp."+model.balance
                onClicked: notbalance.onClickedAction()
            }
        }
    }

    //nambah data hanya dari sini
    RoundButton {
        id: createButton
        //text: qsTr("+")
        icon.name: "plus"
        icon.height: 36
        icon.width: 36
        icon.color: Material.background
        highlighted: true
        anchors.margins: 10
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 70
        width: height
        //font.pointSize: 35
        visible: true
    }
}
