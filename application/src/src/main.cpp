// Default empty project template
#include "WallpaperRuler.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>

#include <QDebug>

#include <Qt/qdeclarativedebug.h>

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

    WallpaperRuler *wpr = new WallpaperRuler(&translator, &app );

    // create scene document from main.qml asset
	// set parent to created document to ensure it exists for the whole application lifetime
    bb::cascades::QmlDocument *qml = bb::cascades::QmlDocument::create("asset:///main.qml").parent(wpr);

	// Make the AppSettings instance available to QML as _appSettings
	qml->setContextProperty("_appSettings", wpr->getAppSettings());

	// Make the AppSettings instance available to QML as _appLocalization
	qml->setContextProperty("_appLocalization", wpr->getAppLocalization());

	// Make the CameraManager instance available to QML as _cameraManager
	qml->setContextProperty("_cameraManager", wpr->getCameraManager());

	// Make the ImageEditor instance used for saving an edited image
	qml->setContextProperty("_imageEditor", wpr->getImageEditor());

	// Make the Model instance, used for creating the IIC, available to QML as _imageGridDataProvider
	qml->setContextProperty("_imageGridDataProvider", wpr->getImageGridDataProvider());

	// create root object for the UI
	bb::cascades::AbstractPane *root = qml->createRootObject<bb::cascades::AbstractPane>();

	// set created root object as a scene
	app.setScene(root);

    // we complete the transaction started in the app constructor and start the client event loop here
    return bb::cascades::Application::exec();
    // when loop is exited the Application deletes the scene which deletes all its children (per qt rules for children)
}
