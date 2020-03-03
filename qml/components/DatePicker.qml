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
    Timer{
        running: true
        repeat: false
        interval: 500
        onTriggered: {
            tumbler.setCurrentIndexAt(2,(selectingDate.getFullYear() - 2000),500);
            tumbler.setCurrentIndexAt(1,(selectingDate.getMonth()),500);
            tumbler.setCurrentIndexAt(0,(selectingDate.getDate()-1),500);
            console.log(selectingDate.getFullYear() - 2000)
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
        readonly property var days: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

        TumblerColumn {
            id: tumblerDayColumn

            function updateModel() {
                var previousIndex = tumblerDayColumn.currentIndex;
                var newDays = tumbler.days[monthColumn.currentIndex];

                if (!model) {
                    var array = [];
                    for (var i = 0; i < newDays; ++i) {
                        array.push(i + 1);
                    }
                    model = array;
                } else {
                    // If we've already got days in the model, just add or remove
                    // the minimum amount necessary to make spinning the month column fast.
                    var difference = model.length - newDays;
                    if (model.length > newDays) {
                        model.splice(model.length - 1, difference);
                    } else {
                        var lastDay = model[model.length - 1];
                        for (i = lastDay; i < lastDay + difference; ++i) {
                            model.push(i + 1);
                        }
                    }
                }

                tumbler.setCurrentIndexAt(0, Math.min(newDays - 1, previousIndex));
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
        }
    }
}
