import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    id:mother
    property date currentDate : new Date()
    property string theYearString: eTransaksi.year
    onTheYearStringChanged:dayTimer.running = true
    property double totalbalance: 0

    header: ToolBar{
        id : theToolbar
        width: parent.width
        visible : (tabBar.currentIndex == 2) ? true : false
        ToolButton{
            icon.name: "chevron_left"
            onClicked: {
                var x = mother.currentDate.getFullYear() - 1;
                var y = mother.currentDate;
                y.setFullYear(x);
                mother.currentDate = y;
                console.log(mother.currentDate.getMonth());
                dayTimer.running = true;
            }
            anchors.left: parent.left
            padding: 10
        }

        Label {
            text: mother.currentDate.toLocaleString(Qt.locale("en_US"),"yyyy")
            font.pixelSize: Qt.application.font.pixelSize * 2
            padding: 10
            anchors.horizontalCenter: parent.horizontalCenter
        }

        ToolButton{
            icon.name: "chevron_right"
            onClicked: {
                var x = mother.currentDate.getFullYear() + 1;
                var y = mother.currentDate;
                y.setFullYear(x);
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
            id_transaksi:1
            waktu_dibuat:"2020-02-20"
            id_kategori:1
            keterangan:"keterangan"
            debet:90
            kredit:90
            nama_kategori:"nama"
            id_icon:1
            warna_icon:"warna"
            nama_icon:"nama_icon"
        }
    }

    Timer{
        id:dayTimer
        interval: 1
        repeat: false
        running: true
        onTriggered: {
            var colocolo = new Date();
            eTransaksi.selectYear(mother.currentDate);
            datemodel.clear();
            console.log(JSON.stringify(eTransaksi.year));
            var jicons = JSON.parse(eTransaksi.year).transaksi;
            var balance = 0;
            for(var i=0;i<jicons.length;i++){
                datemodel.append({
                                     id_transaksi:jicons[i].id_transaksi,
                                     waktu_dibuat:jicons[i].waktu_dibuat,
                                     id_kategori:jicons[i].id_kategori,
                                     keterangan:jicons[i].keterangan,
                                     debet:jicons[i].debet,
                                     kredit:jicons[i].kredit,
                                     nama_kategori:jicons[i].nama_kategori,
                                     warna_icon:jicons[i].warna_icon,
                                     nama_icon:jicons[i].nama_icon,
                                     id_icon:jicons[i].id_icon
                                 });
                balance = (balance + jicons[i].debet) -  jicons[i].kredit;
            }
            mother.totalbalance = balance;
        }
    }

    ListView{
        model: datemodel
        anchors.fill: parent
        height: parent.height - theToolbar.height
        clip: true
        header: ItemDelegate{
            width: parent.width
            icon.name: "default"
            text: "Total Balance : "+Number(mother.totalbalance).toLocaleCurrencyString(Qt.locale("id_ID"))
        }

        delegate: Row{
            width: parent.width
            ItemDelegate{
                id:iconShow
                icon.name : model.nama_icon
                icon.color: model.warna_icon
                onClicked: notbalance.onClickedAction()
            }

            ItemDelegate{
                id:notbalance
                width: parent.width - balance.width - iconShow.width
                hoverEnabled: false
                onClicked: onClickedAction()
                leftPadding: 0
                rightPadding: 0
                property bool kthidden: false
                contentItem: Column{
                    Label{
                        text: model.keterangan
                        font.bold: true
                    }
                    Label{
                        id:kategorinama
                        text: model.nama_kategori
                        font.pixelSize: Qt.application.font.pixelSize * 0.8
                        visible: true
                    }
                    Label{
                        id:waktunama
                        text: new Date(model.waktu_dibuat).toLocaleDateString()
                        font.pixelSize: Qt.application.font.pixelSize * 0.8
                        visible: false
                    }
                }
                Timer{
                    id:showtimer
                    interval: 2500
                    running: true
                    repeat: true
                    onTriggered: {
                        if(notbalance.kthidden){
                            waktunama.visible = false
                            kategorinama.visible = true
                            notbalance.kthidden = false
                        }
                        else{
                            waktunama.visible = true
                            kategorinama.visible = false
                            notbalance.kthidden = true
                        }
                    }
                }

                function onClickedAction(){
                    console.log("clicked")
                }
            }
            ItemDelegate{
                id:balance
                hoverEnabled: false
                anchors.verticalCenter: notbalance.verticalCenter
                text: Number((Number(model.debet) - Number(model.kredit))).toLocaleCurrencyString(Qt.locale("id_ID"))
                onClicked: notbalance.onClickedAction()
                leftPadding: 0
            }
        }
    }
}
