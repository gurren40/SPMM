import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Extras 1.4

Item{
    id:mother
    //anchors.centerIn: parent
    width: 200
    height: 400
    //property date selectingDate: new Date()
    property date selectingDate : new Date()
    property bool disableSelectingDate: true

    Timer{
        running: true
        repeat: false
        interval: 500
        onTriggered: {
            tumbler.setCurrentIndexAt(2,(selectingDate.getFullYear() - 2000),500);
            tumbler.setCurrentIndexAt(1,(selectingDate.getMonth()),500);
            tumbler.setCurrentIndexAt(0,(selectingDate.getDate()-1),500);
            console.log(selectingDate.getFullYear() - 2000);
            mother.disableSelectingDate = false;
        }
    }

    function updateSelectingDate(){
        if(!mother.disableSelectingDate){
            var newDate = new Date(Number(yearColumn.currentIndex)+2000,Number(monthColumn.currentIndex),Number(tumblerDayColumn.currentIndex)+1);
            mother.selectingDate = newDate;
        }
    }

    Tumbler {
        id: tumbler
        anchors.centerIn: parent

        // TODO: Use FontMetrics with 5.4
        Label {
            id: characterMetrics
            font.bold: true
            visible: false
            text: "M"
        }

        readonly property real delegateTextMargins: characterMetrics.width * 1.5

        TumblerColumn {
            id: tumblerDayColumn
            model:ListModel{
                Component.onCompleted: {
                    var theMonth = new Date(selectingDate.getFullYear(),Number(selectingDate.getMonth()) + 1,0);
                    for(var i = 1;i<=theMonth.getDate();i++){
                        append({value:i});
                    }
                }
            }
            onCurrentIndexChanged: mother.updateSelectingDate();

            function updateModel() {
                var previousIndex = tumblerDayColumn.currentIndex;

                tumblerDayColumn.model.clear();
                var theMonth = new Date(Number(yearColumn.currentIndex)+2000,Number(monthColumn.currentIndex) + 1,0);
                for(var i = 1;i<=theMonth.getDate();i++){
                    tumblerDayColumn.model.append({value:i});
                }

                tumbler.setCurrentIndexAt(0, previousIndex);
                mother.updateSelectingDate();
            }
        }
        TumblerColumn {
            id: monthColumn
            width: characterMetrics.width * 3 + tumbler.delegateTextMargins
            model: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
            onCurrentIndexChanged: tumblerDayColumn.updateModel()
        }
        TumblerColumn {
            id:yearColumn
            width: characterMetrics.width * 4 + tumbler.delegateTextMargins
            model: ListModel {
                Component.onCompleted: {
                    for (var i = 2000; i < 2100; ++i) {
                        append({value: i.toString()});
                    }
                }
            }
            onCurrentIndexChanged: tumblerDayColumn.updateModel()
        }
    }
}
