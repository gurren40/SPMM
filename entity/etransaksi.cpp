#include "etransaksi.h"

Etransaksi::Etransaksi(QSqlDatabase *database, QObject *parent) : QObject(parent)
{
    m_database = database;
    lastSelectedDate = QDate();
}

QString Etransaksi::today()
{
    QJsonObject response;
    QJsonArray mTransaksi;
    QSqlQuery query;
    bool ok;
    QString textQuery = "SELECT * FROM ((transaksi LEFT JOIN kategori ON transaksi.id_kategori = kategori.id_kategori) LEFT JOIN icon ON kategori.id_icon = icon.id_icon) WHERE date(transaksi.waktu_dibuat) == date('now');";
    if(m_database->open()){
        QTextStream(stdout) << textQuery << "\n\n";
        ok = query.exec(textQuery);
        if(ok){
            mTransaksi = parseSql(query);
            response["error"] = "0";
            response["transaksi"] = mTransaksi;
        }
        else response["error"] = query.lastError().text();
    }
    else response["error"] = m_database->lastError().text();
    this->day = QJsonDocument(response).toJson();
    emit jsonDataChanged();
    return QJsonDocument(response).toJson();
}

QString Etransaksi::thisMonth()
{
    QJsonObject response;
    QJsonArray mTransaksi;
    QSqlQuery query;
    bool ok;
    QString textQuery = "SELECT * FROM ((transaksi LEFT JOIN kategori ON transaksi.id_kategori = kategori.id_kategori) LEFT JOIN icon ON kategori.id_icon = icon.id_icon) WHERE strftime('%Y-%m', transaksi.waktu_dibuat) == strftime('%Y-%m', 'now');";
    if(m_database->open()){
        QTextStream(stdout) << textQuery << "\n\n";
        ok = query.exec(textQuery);
        if(ok){
            mTransaksi = parseSql(query);
            response["error"] = "0";
            response["transaksi"] = mTransaksi;
        }
        else response["error"] = query.lastError().text();
    }
    else response["error"] = m_database->lastError().text();
    this->month = QJsonDocument(response).toJson();
    emit jsonDataChanged();
    return QJsonDocument(response).toJson();
}

QString Etransaksi::thisYear()
{
    QJsonObject response;
    QJsonArray mTransaksi;
    QSqlQuery query;
    bool ok;
    QString textQuery = "SELECT * FROM ((transaksi LEFT JOIN kategori ON transaksi.id_kategori = kategori.id_kategori) LEFT JOIN icon ON kategori.id_icon = icon.id_icon) WHERE strftime('%Y', transaksi.waktu_dibuat) == strftime('%Y', 'now');";
    if(m_database->open()){
        QTextStream(stdout) << textQuery << "\n\n";
        ok = query.exec(textQuery);
        if(ok){
            mTransaksi = parseSql(query);
            response["error"] = "0";
            response["transaksi"] = mTransaksi;
        }
        else response["error"] = query.lastError().text();
    }
    else response["error"] = m_database->lastError().text();
    this->year = QJsonDocument(response).toJson();
    emit jsonDataChanged();
    return QJsonDocument(response).toJson();
}

QString Etransaksi::createTransaksi(QDate waktu_dibuat, int id_kategori, QString keterangan, double debet, double kredit)
{
    QString textQuery = "INSERT INTO `transaksi` (`waktu_dibuat`,`id_kategori`,`keterangan`,`debet`,`kredit`) VALUES ('"+waktu_dibuat.toString(Qt::ISODate)+"','"+QString::number(id_kategori)+"','"+keterangan+"','"+QString::number(debet)+"','"+QString::number(kredit)+"');";
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
    this->selectDate(lastSelectedDate);
    return QJsonDocument(response).toJson();
}

QString Etransaksi::updateTransaksi(int id_transaksi, QDate waktu_dibuat, int id_kategori, QString keterangan, double debet, double kredit)
{
    //QString textQuery = "UPDATE `transaksi` SET (`waktu_dibuat`,`id_kategori`,`keterangan`,`debet`,`kredit`) VALUES ('"+waktu_dibuat.toString(Qt::ISODate)+"','"+QString::number(id_kategori)+"','"+keterangan+"','"+QString::number(debet)+"','"+QString::number(kredit)+"') WHERE `id_transaksi` = '"+QString::number(id_transaksi)+"';";
    QString textQuery = "UPDATE `transaksi` SET waktu_dibuat='"+waktu_dibuat.toString(Qt::ISODate)+"',id_kategori='"+QString::number(id_kategori)+"',keterangan='"+keterangan+"',debet='"+QString::number(debet)+"',kredit='"+QString::number(kredit)+"' WHERE id_transaksi='"+QString::number(id_transaksi)+"';";
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
    this->selectDate(lastSelectedDate);
    return QJsonDocument(response).toJson();
}

QString Etransaksi::deleteTransaksi(int id_transaksi)
{
    QString textQuery = "DELETE FROM `transaksi` WHERE id_transaksi = '"+QString::number(id_transaksi)+"';";
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
    this->selectDate(lastSelectedDate);
    return QJsonDocument(response).toJson();
}

QString Etransaksi::getRanged() const
{
    return ranged;
}

QString Etransaksi::getYear() const
{
    return year;
}

QString Etransaksi::getMonth() const
{
    return month;
}

QString Etransaksi::getDay() const
{
    return day;
}

QJsonArray Etransaksi::parseSql(QSqlQuery query)
{
    QJsonArray mTransaksi;
    while (query.next()){
        QJsonObject transaksi;
        transaksi["id_transaksi"] = query.value("transaksi.id_transaksi").toInt();
        transaksi["waktu_dibuat"] = query.value("transaksi.waktu_dibuat").toString();
        transaksi["id_kategori"] = query.value("transaksi.id_kategori").toInt();
        transaksi["keterangan"] = query.value("transaksi.keterangan").toString();
        transaksi["debet"] = query.value("transaksi.debet").toDouble();
        transaksi["kredit"] = query.value("transaksi.kredit").toDouble();
        transaksi["nama_kategori"] = query.value("kategori.nama_kategori").toString();
        transaksi["id_icon"] = query.value("kategori.id_icon").toInt();
        transaksi["warna_icon"] = query.value("kategori.warna_icon").toString();
        transaksi["nama_icon"] = query.value("icon.nama_icon").toString();
        mTransaksi.append(transaksi);
    }
    return mTransaksi;
}

QString Etransaksi::selectDate(QDate date)
{
    QJsonObject response;
    QJsonArray mTransaksi;
    QSqlQuery query;
    bool ok;
    QString textQuery = "SELECT * FROM ((transaksi LEFT JOIN kategori ON transaksi.id_kategori = kategori.id_kategori) LEFT JOIN icon ON kategori.id_icon = icon.id_icon) WHERE date(transaksi.waktu_dibuat) == date('"+date.toString(Qt::ISODate)+"') ORDER BY transaksi.waktu_dibuat ASC;";
    if(m_database->open()){
        QTextStream(stdout) << textQuery << "\n\n";
        ok = query.exec(textQuery);
        if(ok){
            mTransaksi = parseSql(query);
            response["error"] = "0";
            response["transaksi"] = mTransaksi;
        }
        else response["error"] = query.lastError().text();
    }
    else response["error"] = m_database->lastError().text();
    this->day = QJsonDocument(response).toJson();
    emit jsonDataChanged();
    this->lastSelectedDate = date;
    return QJsonDocument(response).toJson();
}

QString Etransaksi::selectMonth(QDate month)
{
    QJsonObject response;
    QJsonArray mTransaksi;
    QSqlQuery query;
    bool ok;
    QString textQuery = "SELECT * FROM ((transaksi LEFT JOIN kategori ON transaksi.id_kategori = kategori.id_kategori) LEFT JOIN icon ON kategori.id_icon = icon.id_icon) WHERE strftime('%Y-%m', transaksi.waktu_dibuat) == strftime('%Y-%m', '"+month.toString(Qt::ISODate)+"') ORDER BY transaksi.waktu_dibuat ASC;";
    if(m_database->open()){
        QTextStream(stdout) << textQuery << "\n\n";
        ok = query.exec(textQuery);
        if(ok){
            mTransaksi = parseSql(query);
            response["error"] = "0";
            response["transaksi"] = mTransaksi;
        }
        else response["error"] = query.lastError().text();
    }
    else response["error"] = m_database->lastError().text();
    this->month = QJsonDocument(response).toJson();
    emit jsonDataChanged();
    return QJsonDocument(response).toJson();
}

QString Etransaksi::selectYear(QDate year)
{
    QJsonObject response;
    QJsonArray mTransaksi;
    QSqlQuery query;
    bool ok;
    QString textQuery = "SELECT * FROM ((transaksi LEFT JOIN kategori ON transaksi.id_kategori = kategori.id_kategori) LEFT JOIN icon ON kategori.id_icon = icon.id_icon) WHERE strftime('%Y', transaksi.waktu_dibuat) == strftime('%Y', '"+year.toString(Qt::ISODate)+"') ORDER BY transaksi.waktu_dibuat ASC;";
    if(m_database->open()){
        QTextStream(stdout) << textQuery << "\n\n";
        ok = query.exec(textQuery);
        if(ok){
            mTransaksi = parseSql(query);
            response["error"] = "0";
            response["transaksi"] = mTransaksi;
        }
        else response["error"] = query.lastError().text();
    }
    else response["error"] = m_database->lastError().text();
    this->year = QJsonDocument(response).toJson();
    emit jsonDataChanged();
    return QJsonDocument(response).toJson();
}

QString Etransaksi::selectRangeDate(QDate date1, QDate date2)
{
    QJsonObject response;
    QJsonArray mTransaksi;
    QSqlQuery query;
    bool ok;
    QString textQuery = "SELECT * FROM ((transaksi LEFT JOIN kategori ON transaksi.id_kategori = kategori.id_kategori) LEFT JOIN icon ON kategori.id_icon = icon.id_icon) WHERE date(transaksi.waktu_dibuat) BETWEEN date('"+date1.toString(Qt::ISODate)+"') AND date('"+date2.toString(Qt::ISODate)+"');";
    if(m_database->open()){
        QTextStream(stdout) << textQuery << "\n\n";
        ok = query.exec(textQuery);
        if(ok){
            mTransaksi = parseSql(query);
            response["error"] = "0";
            response["transaksi"] = mTransaksi;
        }
        else response["error"] = query.lastError().text();
    }
    else response["error"] = m_database->lastError().text();
    this->ranged = QJsonDocument(response).toJson();
    emit dateSearchChanged();
    return QJsonDocument(response).toJson();
}
