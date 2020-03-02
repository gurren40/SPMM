#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtSvg>
#include <QIcon>
#include <QFile>
#include <QStandardPaths>
#include <QSqlDatabase>
#include <QDataStream>
#include <QSettings>
#include <QDir>

//files
#include "entity/ekategori.h"
#include "entity/etransaksi.h"


QSqlDatabase opendb(QString path){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(path);
    return db;
}

QSqlDatabase copydb(){
    QFile dbfile(":/db/spmm.sqlite");
    dbfile.open(QIODevice::ReadOnly);
    QDir fileDir;
    QString fileloc = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)+"/spmm.sqlite";
    if(fileDir.exists(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation))){
        QTextStream(stdout) << "dir sudah ada";
    }
    else{
        fileDir.mkpath(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
        QTextStream(stdout) << "buat dir";
    }
    if(!dbfile.exists(fileloc)){
        dbfile.copy(fileloc);
        QFile(fileloc).setPermissions(QFileDevice::ReadOwner | QFileDevice::WriteOwner);
    }
    else{
        QTextStream(stdout) << "File sudah ada";
    }
    QFile filetercopy(fileloc);
    if(!filetercopy.open(QIODevice::ReadWrite)){
        QTextStream(stdout) << "tidak bisa dibaca dan ditulis";
    }
    return opendb(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)+"/spmm.sqlite");
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication::setApplicationName("Simple Personal Money Manager");
    QGuiApplication::setOrganizationDomain("spmm.local");
    QGuiApplication::setOrganizationName("Witchcraft");
    QGuiApplication app(argc, argv);

    QIcon::setThemeName("witchcraft");

    QSettings settings;
    settings.setValue("name","witchcraft");

    qDebug() << QSqlDatabase::drivers();
    QSqlDatabase db = copydb();
    Ekategori kategori(&db);
    Etransaksi transaksi(&db);

    QTextStream(stdout) << kategori.readIcon();

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.rootContext()->setContextProperty(QStringLiteral("eTransaksi"), &transaksi);
    engine.rootContext()->setContextProperty(QStringLiteral("eKategori"), &kategori);

    engine.load(url);

    return app.exec();
}
