#ifndef ETRANSAKSI_H
#define ETRANSAKSI_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QVector>
#include <QTextStream>
#include <QDate>

class Etransaksi : public QObject
{
    Q_OBJECT
public:
    explicit Etransaksi(QSqlDatabase *database, QObject *parent = nullptr);

signals:
    void jsonDataChanged();

public:

    //read data
    QJsonObject today();
    QJsonObject thisMonth();
    QJsonObject thisYear();
    //QJsonArray selectDate(QDate date);
    //QJsonArray selectRangeDate(QDate date1, QDate date2);

    //cud
    QJsonObject createTransaksi(QDate waktu_dibuat,int id_kategori,QString keterangan,double debet, double kredit);
    QJsonObject updateTransaksi(int id_transaksi,QDate waktu_dibuat,int id_kategori,QString keterangan,double debet, double kredit);
    QJsonObject deleteTransaksi(int id_transaksi);

    QString jsondata;

private:
    QSqlDatabase* m_database;
};

#endif // ETRANSAKSI_H
