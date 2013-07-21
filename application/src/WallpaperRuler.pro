APP_NAME = WallpaperRuler

CONFIG += qt warn_on cascades10

# Turns off all calls to qDebug() - nothing appears on the console.
#DEFINES += QT_NO_DEBUG_OUTPUT

LIBS += -lbb -lbbcascadesmultimedia -lscreen -lbbsystem

include(config.pri)
