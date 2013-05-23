#include "WallpaperRuler.hpp"

#include <QDebug>
#include <bb/cascades/Application>

using namespace bb::cascades;

WallpaperRuler::WallpaperRuler(QTranslator *translator, QObject *parent)
	: QObject(parent)
{

	qDebug() << "[WallpaperRuler::WallpaperRuler]";

	this->initialize(translator);
}

void WallpaperRuler::initialize(QTranslator *translator) {
	qDebug() << "[WallpaperRuler::initialize]";

	// Create the AppSettings instance
	this->appSettings = new AppSettings(this);

	// read the App Language Property
	QString appLang = this->appSettings->getValueFor( AppSettings::APP_LANG, QString("en") );

	// create the AppLocalization instance
	this->appLocalization = new AppLocalization(translator, this);
	this->appLocalization->loadTranslator(appLang);

	// Initialize the Model
	this->imageGridDataProvider = new ImageGridDataProvider();

	// create the CameraManager instance passing the imageGridDataProvider instance
	this->cameraManager = new CameraManager(this->imageGridDataProvider);

	// This signal is fired when the application is minimized (active frame)
	bool ok = connect( Application::instance(), SIGNAL(thumbnail()), this, SLOT(onActiveFrame()));
	if (!ok) {
		qDebug() << "connect thumbnail failed";
	}
}

// triggered if Application is minimized (Active Frame)
void WallpaperRuler::onActiveFrame() {
	// TODO set Cover()
	qDebug() << "[WallpaperRuler::onActiveFrame] Application is now an Active Frame (minimized)";
	// AbstractCover *cover;
	// Application::instance()->setCover(cover);
}

AppSettings* WallpaperRuler::getAppSettings() {
	qDebug() << "[WallpaperRuler::getAppSettings]";
	return this->appSettings;
}

AppLocalization* WallpaperRuler::getAppLocalization() {
	qDebug() << "[WallpaperRuler::getAppLocalization]";
	return this->appLocalization;
}

ImageGridDataProvider* WallpaperRuler::getImageGridDataProvider(){
	qDebug() << "[WallpaperRuler::getImageGridDataProvider]";
	return this->imageGridDataProvider;
}

CameraManager* WallpaperRuler::getCameraManager(){
	qDebug() << "[WallpaperRuler::getCameraManager]";
	return this->cameraManager;
}
