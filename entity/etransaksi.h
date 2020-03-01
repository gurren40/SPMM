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
    Q_PROPERTY(QString dayTr READ today NOTIFY jsonDataChanged)
    Q_PROPERTY(QString monthTr READ thisMonth NOTIFY jsonDataChanged)
    Q_PROPERTY(QString yearTr READ thisYear NOTIFY jsonDataChanged)
    Q_PROPERTY(QString selectedDate READ getSelectDateStr NOTIFY dateSearchChanged)
    Q_PROPERTY(QString selectedRangeDate READ getSelectRangeDateStr NOTIFY dateSearchChanged)
public:
    explicit Etransaksi(QSqlDatabase *database, QObject *parent = nullptr);

signals:
    void jsonDataChanged();
    void dateSearchChanged();

public:

    //read data
    QString today();
    QString thisMonth();
    QString thisYear();

    //misc function
    QJsonArray parseSql(QSqlQuery query);

    QString getSelectDateStr() const;
    QString getSelectRangeDateStr() const;

public slots:
    //read by date
    QString selectDate(QString date);
    QString selectRangeDate(QString date1, QString date2);
    //cud
    QString createTransaksi(QDate waktu_dibuat,int id_kategori,QString keterangan,double debet, double kredit);
    QString updateTransaksi(int id_transaksi,QDate waktu_dibuat,int id_kategori,QString keterangan,double debet, double kredit);
    QString deleteTransaksi(int id_transaksi);

private:
    QSqlDatabase* m_database;
    QString selectDateStr;
    QString selectRangeDateStr;
};

#endif // ETRANSAKSI_H
