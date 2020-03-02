#include "ekategori.h"

Ekategori::Ekategori(QSqlDatabase *database, QObject *parent) : QObject(parent)
{
    m_database = database;
}

QString Ekategori::readKategori()
{
    QJsonObject response;
    QJsonArray mTransaksi;
    QSqlQuery query;
    bool ok;
    QString textQuery = "SELECT * FROM (kategori LEFT JOIN icon ON kategori.id_icon = icon.id_icon) WHERE 1;";
    if(m_database->open()){
        QTextStream(stdout) << textQuery << "\n\n";
        ok = query.exec(textQuery);
        if(ok){
            mTransaksi = parseSql(query);
            response["error"] = "0";
            response["kategori"] = mTransaksi;
        }
        else response["error"] = query.lastError().text();
    }
    else response["error"] = m_database->lastError().text();
    return QJsonDocument(response).toJson();
}

QString Ekategori::readIcon()
{
    QJsonObject response;
    QJsonArray mTransaksi;
    QSqlQuery query;
    bool ok;
    QString textQuery = "SELECT * FROM icon WHERE 1;";
    if(m_database->open()){
        QTextStream(stdout) << textQuery << "\n\n";
        ok = query.exec(textQuery);
        if(ok){
            while (query.next()){
                QJsonObject transaksi;
                transaksi["id_icon"] = query.value("icon.id_icon").toInt();
                transaksi["nama_icon"] = query.value("icon.nama_icon").toString();
                mTransaksi.append(transaksi);
            }
            response["error"] = "0";
            response["icon"] = mTransaksi;
        }
        else response["error"] = query.lastError().text();
    }
    else response["error"] = m_database->lastError().text();
    return QJsonDocument(response).toJson();
}

QString Ekategori::createKategori(QString nama_kategori,int id_icon, QString warna_icon)
{
    QString textQuery = "INSERT INTO `kategori` (`nama_kategori`,`id_icon`,`warna_icon`) VALUES ('"+nama_kategori+"','"+QString::number(id_icon)+"','"+warna_icon+"');";
    QSqlQuery query;
    QJsonObject response;
    bool ok;

    if(m_database->open()){
        QTextStream(stdout) << textQuery << "\n\n";
        ok = query.exec(textQuery);
        if(ok) response["error"] = "0";
        else {
            QTextStream(stdout) << "Error Query : " << query.lastError().text() << "\n";
            response["error"] = query.lastError().text();
        }
    }
    else response["error"] = m_database->lastError().text();
    emit categoryChanged();
    return QJsonDocument(response).toJson();
}

QString Ekategori::updateKategori(int id_kategori, QString nama_kategori,int id_icon, QString warna_icon)
{
    QString textQuery = "UPDATE `kategori` SET nama_kategori='"+nama_kategori+"',id_icon='"+QString::number(id_icon)+"',warna_icon='"+warna_icon+"' WHERE id_kategori='"+QString::number(id_kategori)+"';";
    QSqlQuery query;
    QJsonObject response;
    bool ok;

    if(m_database->open()){
        QTextStream(stdout) << textQuery << "\n\n";
        ok = query.exec(textQuery);
        if(ok) response["error"] = "0";
        else {
            QTextStream(stdout) << "Error Query : " << query.lastError().text() << "\n";
            response["error"] = query.lastError().text();
        }
    }
    else response["error"] = m_database->lastError().text();
    emit categoryChanged();
    return QJsonDocument(response).toJson();
}

QString Ekategori::deleteKategori(int id_kategori)
{
    QString textQuery = "DELETE FROM `kategori` WHERE id_kategori = '"+QString::number(id_kategori)+"';";
    QSqlQuery query;
    QJsonObject response;
    bool ok;

    if(m_database->open()){
        QTextStream(stdout) << textQuery << "\n\n";
        ok = query.exec(textQuery);
        if(ok) response["error"] = "0";
        else {
            QTextStream(stdout) << "Error Query : " << query.lastError().text() << "\n";
            response["error"] = query.lastError().text();
        }
    }
    else response["error"] = m_database->lastError().text();
    emit categoryChanged();
    return QJsonDocument(response).toJson();
}

QJsonArray Ekategori::parseSql(QSqlQuery query)
{
    QJsonArray mTransaksi;
    while (query.next()){
        QJsonObject transaksi;
        transaksi["id_kategori"] = query.value("kategori.id_kategori").toInt();
        transaksi["nama_kategori"] = query.value("kategori.nama_kategori").toString();
        transaksi["id_icon"] = query.value("kategori.id_icon").toInt();
        transaksi["warna_icon"] = query.value("kategori.warna_icon").toString();
        transaksi["nama_icon"] = query.value("icon.nama_icon").toString();
        mTransaksi.append(transaksi);
    }
    return mTransaksi;
}
