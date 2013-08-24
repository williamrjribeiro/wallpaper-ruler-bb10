// Default empty project template
#include "WallpaperRuler.hpp"

#include <bb/cascades/Application>

#include <QDebug>

#include <Qt/qdeclarativedebug.h>

 #define QT_USE_FAST_CONCATENATION
 #define QT_USE_FAST_OPERATOR_PLUS

Q_DECL_EXPORT int main(int argc, char **argv)
{
    // this is where the server is started etc
	bb::cascades::Application app(argc, argv);

    // localization support
    QTranslator translator;
    QString locale_string = QLocale().name();
    qDebug() << "[main] locale_string: " << locale_string;\

    QString filename = QString( "WallpaperRuler_%1" ).arg( locale_string );
    if (translator.load(filename, "app/native/qm")) {
        app.installTranslator( &translator );
    }
    else{
    	qDebug() << "Unable to install QTranslator! filename: " << filename;
    }

    new WallpaperRuler(&app);

    // we complete the transaction started in the app constructor and start the client event loop here
    return bb::cascades::Application::exec();
    // when loop is exited the Application deletes the scene which deletes all its children (per qt rules for children)
}
