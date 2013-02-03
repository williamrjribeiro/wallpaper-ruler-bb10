// Default empty project template
#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>

#include "WallpaperRuler.hpp"

using namespace bb::cascades;
using namespace wpr;

Q_DECL_EXPORT int main(int argc, char **argv)
{
    // this is where the server is started etc
    Application app(argc, argv);

    // localization support
    QTranslator translator;
    /*QString locale_string = QLocale().name();
    qDebug() << "[main] locale_string: " << locale_string;\

    QString filename = QString( "WallpaperRuler_%1" ).arg( locale_string );
    if (translator.load(filename, "app/native/qm")) {
        app.installTranslator( &translator );
    }
    else{
    	qDebug() << "Unable to install QTranslator! filename: " << filename;
    }*/

    new WallpaperRuler(&app, &translator);

    // we complete the transaction started in the app constructor and start the client event loop here
    return Application::exec();
    // when loop is exited the Application deletes the scene which deletes all its children (per qt rules for children)
}
