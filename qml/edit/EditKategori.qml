import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.3
import Qt.labs.platform 1.0

Page {
    id:mother
    property int id_kategori: 0
    property string nama_kategori: "nama_kategori"
    property int id_icon: 0
    property string warna_icon: "white"

    property date currentDate : new Date()
    property string iconString: eKategori.icons
    onIconStringChanged: mother.refreshIconList()

    ListModel{
        id:iconListModel
        ListElement{
            nama_icon:"power"
            id_icon:1
        }
    }

    function refreshIconList(){
        iconListModel.clear();
        var jicons = JSON.parse(mother.iconString).icon;
        console.log(JSON.stringify(jicons));
        for(var i=0;i<jicons.length;i++){
            iconListModel.append({nama_icon:jicons[i].nama_icon,id_icon:jicons[i].id_icon});
        }
    }

    Timer{
        id:loadTimer
        interval: 1
        repeat: false
        running: true
        onTriggered: {
            mother.refreshIconList()
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
                    text: "Edit Category"
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
                        Label{
                            width: parent.width
                            text: "Category Name"
                            font.pixelSize: Qt.application.font.pixelSize * 1
                        }
                        TextField{
                            id : nama_kategori
                            width: parent.width
                            text: mother.nama_kategori
                        }
                    }
                }
                ItemDelegate{
                    width: parent.width
                    hoverEnabled: false
                    contentItem: ComboBox{
                        property string displayName : "***Need to reselect icon***"
                        id : newIcon
                        textRole: "id_icon"
                        displayText: displayName
                        width: parent.width
                        model: iconListModel
                        delegate: ItemDelegate{
                            width: parent.width
                            icon.name : model.nama_icon
                            text: model.nama_icon
                            onClicked: {
                                newIcon.displayName = model.nama_icon
                            }
                        }
                    }
                }
                Label{
                    text: " "
                }
                ItemDelegate{
                    id:categoryColorChooser
                    width: parent.width
                    icon.color:mother.warna_icon
                    icon.name: "default"
                    text: "Select Icon Color"
                    onClicked: colorDialog.open()
                    ColorDialog {
                        id: colorDialog
                        title: "Please choose a color"
                        visible: false
                        color: value
                        onAccepted: {
                            console.log("You chose: " + colorDialog.color)
                            categoryColorChooser.icon.color = colorDialog.color
                        }
                        onRejected: {
                            console.log("Canceled")
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
                        onClicked: stackView.pop()
                        background: Rectangle{
                            color: Material.primary
                            anchors.fill: parent
                        }
                    }
                    ItemDelegate{
                        text: "Edit"
                        icon.name: "sync"
                        background: Rectangle{
                            color: Material.accent
                            anchors.fill: parent
                        }
                        onClicked: {
                            if((newIcon.displayName != "Select Icon") && (nama_kategori.text != "")){
                                eKategori.updateKategori(mother.id_kategori,nama_kategori.text,newIcon.currentText,categoryColorChooser.icon.color);
                                stackView.pop();
                            }
                            else{
                                console.log("ada yang salah bruh")
                            }
                        }
                    }
                }
            }
        }
    }
}
