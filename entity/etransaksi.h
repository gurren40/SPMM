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
    Q_PROPERTY(QString day READ getDay NOTIFY jsonDataChanged)
    Q_PROPERTY(QString month READ getMonth NOTIFY jsonDataChanged)
    Q_PROPERTY(QString year READ getYear NOTIFY jsonDataChanged)
    Q_PROPERTY(QString ranged READ getRanged NOTIFY jsonDataChanged)

public:
    explicit Etransaksi(QSqlDatabase *database, QObject *parent = nullptr);

signals:
    void jsonDataChanged();
    void dateSearchChanged();

public:
    //misc function
    QJsonArray parseSql(QSqlQuery query);

    QString getDay() const;
    QString getMonth() const;
    QString getYear() const;
    QString getRanged() const;

public slots:
    //read data
    QString today();
    QString thisMonth();
    QString thisYear();
    //read by date
    QString selectDate(QDate date);
    QString selectMonth(QDate month);
    QString selectYear(QDate year);
    QString selectRangeDate(QDate date1, QDate date2);

    //cud
    QString createTransaksi(QDate waktu_dibuat,int id_kategori,QString keterangan,double debet, double kredit);
    QString updateTransaksi(int id_transaksi,QDate waktu_dibuat,int id_kategori,QString keterangan,double debet, double kredit);
    QString deleteTransaksi(int id_transaksi);

private:
    QSqlDatabase* m_database;
    QString day;
    QString month;
    QString year;
    QString ranged;
    QDate lastSelectedDate;
};

#endif // ETRANSAKSI_H
