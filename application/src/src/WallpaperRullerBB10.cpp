#include <bb/cascades/Application>
#include <bb/cascades/AbstractPane>

#include "WallpaperRullerBB10.hpp"

using namespace bb::cascades;


WallpaperRullerBB10::WallpaperRullerBB10(bb::cascades::Application *app): QObject(app) {

	qDebug() << "[WallpaperRullerBB10::WallpaperRullerBB10]";

	// create scene document from main.qml asset
	// set parent to created document to ensure it exists for the whole application lifetime
	this->qml = QmlDocument::create("asset:///main.qml").parent(this);

	// create root object for the UI
	AbstractPane *root = this->qml->createRootObject<AbstractPane>();
	// set created root object as a scene
	app->setScene(root);

	this->initialize();
}

wpr::controller::AppSettings* WallpaperRullerBB10::getAppSettings() {
	qDebug() << "[WallpaperRullerBB10::initialize]";
	return this->appSettings;
}

int WallpaperRullerBB10::initialize() {
	qDebug() << "[WallpaperRullerBB10::initialize]";

	// Set the application organization and name, which is used by QSettings
	// when saving values to the persistent store.
	QCoreApplication::setOrganizationName("Will Thrill");
	QCoreApplication::setApplicationName("Wallpaper Ruler");

	// Create the AppSettings instance
	this->appSettings = new wpr::controller::AppSettings();

	this->qml->setContextProperty("_appSettings", this->appSettings);

	// read the App Language Property
	QString appLang = this->appSettings->getValueFor( wpr::controller::AppSettings::APP_LANG, QString("en") );

	qDebug() << "[WallpaperRullerBB10::initialize] appLang: " << appLang;

	return 0;
}
