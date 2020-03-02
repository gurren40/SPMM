import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12

Page {
    id:mother
    property date currentDate : new Date()
    property string kategoriString: eKategori.categories
    onKategoriStringChanged: kategoriChanged()

    ListModel{
        id:categoryModel
        ListElement{
            id_kategori:1
            nama_kategori:"nama"
            id_icon:1
            warna_icon:"warna"
            nama_icon:"nama_icon"
        }
    }

    function kategoriChanged(){
        categoryModel.clear();
        var jicons = JSON.parse(mother.kategoriString).kategori;
        console.log(JSON.stringify(jicons));
        for(var i=0;i<jicons.length;i++){
            categoryModel.append({nama_icon:jicons[i].nama_icon,id_icon:jicons[i].id_icon,id_kategori:jicons[i].id_kategori,nama_kategori:jicons[i].nama_kategori,warna_icon:jicons[i].warna_icon});
        }
    }

    Timer{
        id:dayTimer
        interval: 1
        repeat: false
        running: true
        onTriggered: kategoriChanged()
    }

    ListView{
        header: ItemDelegate{
            icon.name:"chevron_left"
            text: "Back"
            width: parent.width
            onClicked: stackView.pop()
            background: Rectangle{
                anchors.fill: parent
                color: Material.accent
            }
        }
        footer: ItemDelegate{
            hoverEnabled: false
            text: "Swipe left to edit, or swipe right to delete"
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Qt.application.font.pixelSize * 0.8
        }

        model: categoryModel
        anchors.fill: parent
        height: parent.height - theToolbar.height
        clip: true

        delegate: Row{
            width: parent.width
            SwipeDelegate{
                id:kategori
                width: parent.width
                text: model.nama_kategori
                icon.name : model.nama_icon
                icon.color : model.warna_icon
                hoverEnabled: false
                onClicked: onClickedAction()
                function onClickedAction(){
                    console.log("clicked")
                }
                swipe.right: ItemDelegate{
                    anchors.right: parent.right
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.5
                    text: "Delete"
                    onClicked: {
                        eKategori.deleteKategori(model.id_kategori)
                        console.log("deleted "+model.id_kategori)
                    }
                    background: Rectangle{
                        anchors.fill: parent
                        color: Material.accent
                    }
                }
                swipe.left: ItemDelegate{
                    anchors.left: parent.left
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.5
                    text: "Edit"
                    onClicked: {
                        onClicked: stackView.push("qrc:/qml/edit/EditKategori.qml",{id_kategori:model.id_kategori,nama_kategori:model.nama_kategori,id_icon:model.id_icon,warna_icon:model.warna_icon})
                        console.log("edited "+model.id_kategori)
                    }
                    background: Rectangle{
                        anchors.fill: parent
                        color: Material.accent
                    }
                }
            }
        }
    }
}
