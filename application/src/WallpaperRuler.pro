APP_NAME = MyApplication

CONFIG += qt warn_on cascades10

# Turns off all calls to qDebug() - nothing appears on the console. http://qt-project.org/forums/viewthread/10427
DEFINES += QT_NO_DEBUG_OUTPUT

LIBS += -lbb -lbbcascadesmultimedia -lscreen -lbbsystem -lbbdevice

include(config.pri)
