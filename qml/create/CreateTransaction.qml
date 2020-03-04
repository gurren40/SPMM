import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.3
import Qt.labs.platform 1.0
import "../components"

Page {
    id:mother
    property date currentDate : new Date()
    property string kategoriString: eKategori.categories
    onKategoriStringChanged: mother.refreshKategoriList()

    ListModel{
        id:kategoriListModel
        ListElement{
            id_kategori:1
            nama_kategori:"nama"
            id_icon:1
            warna_icon:"warna"
            nama_icon:"nama_icon"
        }
    }

    function refreshKategoriList(){
        kategoriListModel.clear();
        var jicons = JSON.parse(mother.kategoriString).kategori;
        console.log(JSON.stringify(jicons));
        for(var i=0;i<jicons.length;i++){
            kategoriListModel.append({nama_icon:jicons[i].nama_icon,id_icon:jicons[i].id_icon,id_kategori:jicons[i].id_kategori,nama_kategori:jicons[i].nama_kategori,warna_icon:jicons[i].warna_icon});
        }
    }

    Timer{
        id:loadTimer
        interval: 1
        repeat: false
        running: true
        onTriggered: {
            mother.refreshKategoriList()
        }
    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 40
        ScrollView{
            Layout.fillHeight: true
            Layout.fillWidth: true
            contentWidth: width
            Column{
                spacing: 10
                width: parent.width

                Label{
                    text: " "
                }
                Label{
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "New Transaction"
                    font.pixelSize: Qt.application.font.pixelSize * 2
                }
                Label{
                    text: " "
                }
                ItemDelegate{
                    width: parent.width
                    hoverEnabled: false
                    contentItem: Column{
                        width: parent.width
                        spacing: 10
                        Label{
                            width: parent.width
                            text: "Date :"
                            font.pixelSize: Qt.application.font.pixelSize * 0.9
                        }
                        Label{
                            width: parent.width
                            text: theDate.selectingDate.toLocaleDateString()
                            font.pixelSize: Qt.application.font.pixelSize * 0.9
                        }
                        DatePicker{
                            id:theDate
                            width: parent.width
                            height: 200
                        }
                    }
                }
                Label{
                    text: " "
                }
                ItemDelegate{
                    width: parent.width
                    hoverEnabled: false
                    contentItem: Column{
                        width: parent.width
                        Label{
                            width: parent.width
                            text: "Information :"
                            font.pixelSize: Qt.application.font.pixelSize * 1
                        }
                        TextField{
                            id : keterangan
                            width: parent.width
                        }
                    }
                }
                ItemDelegate{
                    width: parent.width
                    hoverEnabled: false
                    contentItem: ComboBox{
                        property string displayName : "Select Category"
                        id : kategoriBox
                        textRole: "id_kategori"
                        displayText: displayName
                        width: parent.width
                        model: kategoriListModel
                        delegate: ItemDelegate{
                            width: parent.width
                            icon.name : model.nama_icon
                            icon.color: model.warna_icon
                            text: model.nama_kategori
                            onClicked: {
                                kategoriBox.displayName = model.nama_kategori
                            }
                        }
                    }
                }
                Label{
                    text: " "
                }
                ItemDelegate{
                    width: parent.width
                    hoverEnabled: false
                    contentItem: Column{
                        width: parent.width
                        Label{
                            width: parent.width
                            text: "Debet :"
                            font.pixelSize: Qt.application.font.pixelSize * 1
                        }
                        TextField{
                            id : debet
                            width: parent.width
                            text: "0"
                        }
                    }
                }
                ItemDelegate{
                    width: parent.width
                    hoverEnabled: false
                    contentItem: Column{
                        width: parent.width
                        Label{
                            width: parent.width
                            text: "Credit :"
                            font.pixelSize: Qt.application.font.pixelSize * 1
                        }
                        TextField{
                            id : kredit
                            width: parent.width
                            text: "0"
                        }
                    }
                }
                Label{
                    text: " "
                }
                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 20
                    ItemDelegate{
                        text: "Back"
                        icon.name: "chevron_left"
                        hoverEnabled : true
                        onClicked: stackView.pop()
                        background: Rectangle{
                            color: Material.primary
                            anchors.fill: parent
                        }
                    }
                    ItemDelegate{
                        text: "Create"
                        icon.name: "plus"
                        hoverEnabled : true
                        background: Rectangle{
                            color: Material.accent
                            anchors.fill: parent
                        }
                        onClicked: {
                            if((kategoriBox.displayName != "Select Category") && (keterangan.text != "")){
                                eTransaksi.createTransaksi(theDate.selectingDate,kategoriBox.currentText,keterangan.text,debet.text,kredit.text)
                                stackView.pop();
                            }
                            else{
                                console.log("ada yang salah bruh")
                            }
                        }
                    }
                }
                Label{
                    text: " "
                }
            }
        }
    }
}
