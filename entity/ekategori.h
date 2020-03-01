#ifndef EKATEGORI_H
#define EKATEGORI_H

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

class Ekategori : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString icons READ readIcon NOTIFY iconChanged)
    Q_PROPERTY(QString categories READ readKategori NOTIFY categoryChanged)
public:
    explicit Ekategori(QSqlDatabase *database, QObject *parent = nullptr);

signals:
    void categoryChanged();
    void iconChanged();

public:

    //read
    QString readKategori();
    QString readIcon();


    //misc function
    QJsonArray parseSql(QSqlQuery query);

public slots:
    //cud
    QString createKategori(QString nama_kategori,int id_icon, QString warna_icon);
    QString updateKategori(int id_kategori, QString nama_kategori,int id_icon, QString warna_icon);
    QString deleteKategori(int id_kategori);


private:
    QSqlDatabase* m_database;
};

#endif // EKATEGORI_H
