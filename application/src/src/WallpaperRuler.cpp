#include <bb/cascades/Application>
#include <bb/cascades/AbstractPane>

#include "WallpaperRuler.hpp"

using namespace bb::cascades;

WallpaperRuler::WallpaperRuler(bb::cascades::Application *app, QTranslator *translator): QObject(app) {

	qDebug() << "[WallpaperRuler::WallpaperRuler]";

	this->initialize(translator);

	// create scene document from main.qml asset
	// set parent to created document to ensure it exists for the whole application lifetime
	this->qml = QmlDocument::create("asset:///main.qml").parent(this);

	// Make the AppSettings instance available to QML as _appSettings
	this->qml->setContextProperty("_appSettings", this->appSettings);

	// Make the AppSettings instance available to QML as _appLocalization
	this->qml->setContextProperty("_appLocalization", this->appLocalization);

	// create root object for the UI
	AbstractPane *root = this->qml->createRootObject<AbstractPane>();

	// set created root object as a scene
	app->setScene(root);

	bool ok = connect(app, SIGNAL(thumbnail()), this, SLOT(onThumbnail()));
	if (!ok) {
		qDebug() << "connect thumbnail failed";
	}
}

wpr::controller::AppSettings* WallpaperRuler::getAppSettings() {
	qDebug() << "[WallpaperRuler::getAppSettings]";
	return this->appSettings;
}

wpr::controller::AppLocalization* WallpaperRuler::getAppLocalization() {
	qDebug() << "[WallpaperRuler::getAppLocalization]";
	return this->appLocalization;
}

int WallpaperRuler::initialize(QTranslator *translator) {
	qDebug() << "[WallpaperRuler::initialize]";

	// Set the application organization and name, which is used by QSettings
	// when saving values to the persistent store.
	QCoreApplication::setOrganizationName("Will Thrill");
	QCoreApplication::setApplicationName("Wallpaper Ruler");

	// Create the AppSettings instance
	this->appSettings = new wpr::controller::AppSettings();

	// read the App Language Property
	QString appLang = this->appSettings->getValueFor( wpr::controller::AppSettings::APP_LANG, QString("en") );

	// create the AppLocalization instance
	this->appLocalization = new wpr::controller::AppLocalization(translator);
	this->appLocalization->loadTranslator(appLang);

	return 0;
}

// triggered if Application was sent to back
void WallpaperRuler::onThumbnail() {
	// TODO set Cover()
	qDebug() << "[WallpaperRuler::onThumbnail] Application shrinks to thumbnail";
	// AbstractCover *cover;
	// Application::instance()->setCover(cover);
}
