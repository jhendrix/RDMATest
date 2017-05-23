#-------------------------------------------------
#
# Project created by QtCreator 2017-05-04T12:51:32
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = RDMATest
TEMPLATE = app


SOURCES += main.cpp \
           mainwindow.cpp \
           chview.cpp \
            chcapture.cpp \
    gpuinfo.cpp \
    gpuinfoview.cpp

HEADERS  += mainwindow.h \
            chview.h \
            chcapture.h \
    gpuinfo.h \
    gpuinfoview.h

INCLUDEPATH += "K:/Program Files/NVIDIA GPU Computing Toolkit/v8.0/include"

LIBS += -LD:"K:/Program Files/NVIDIA GPU Computing Toolkit/v8.0/lib/x64/"
