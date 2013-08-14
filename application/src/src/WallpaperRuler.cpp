#include "WallpaperRuler.hpp"
#include "ImageLoader.h"

#include <QDebug>
#include <QDateTime>
#include <bb/cascades/Application>

using namespace bb::cascades;

WallpaperRuler::WallpaperRuler(QTranslator *translator, QObject *parent)
	: QObject(parent)
	, appSettings(new AppSettings(this))
	//, appLocalization(new AppLocalization(translator, this))
	, imageEditor(new ImageEditor(this))
	, imageGridDataProvider(new ImageGridDataProvider(this))
	, cameraManager(new CameraManager(this->imageGridDataProvider,this))
	, screenSize(new ScreenSize(this))
{

	// Register custom type to QML
	qmlRegisterType<ImageLoader>();

	// read the App Language Property
	QString appLang = this->appSettings->getValueFor( AppSettings::APP_LANG, QString("en") );

	// create the AppLocalization instance
	//this->appLocalization = new AppLocalization(translator, this);
	//this->appLocalization->loadTranslator(appLang);

	// This signal is fired when the application is minimized (active frame)
	bool ok = connect( Application::instance(), SIGNAL(thumbnail()), this, SLOT(onActiveFrame()));
	if (!ok) {
		qDebug() << "connect thumbnail failed";
	}

	ok = connect( Application::instance(), SIGNAL(aboutToQuit()), this, SLOT(onAboutToQuit()));
	if (!ok) {
		qDebug() << "connect aboutToQuit failed";
	}

	qDebug() << "[WallpaperRuler::WallpaperRuler] m_lastClosed: " << this->appSettings->lastClosed();
}

// triggered if Application is minimized (Active Frame)
void WallpaperRuler::onActiveFrame() {
	// TODO set Cover()
	qDebug() << "[WallpaperRuler::onActiveFrame] Application is now an Active Frame (minimized)";
	// AbstractCover *cover;
	// Application::instance()->setCover(cover);
}

// triggered when the Application is closed
void WallpaperRuler::onAboutToQuit() {
	QString quitDate = QDateTime::currentDateTime().toString(AppSettings::APP_DATE_FORMAT);
	qDebug() << "[WallpaperRuler::onAboutToQuit] Exiting application. quitDate" << quitDate;
	this->appSettings->saveValueFor( AppSettings::APP_LAST_CLOSED, quitDate);
}

AppSettings* WallpaperRuler::getAppSettings() {
	qDebug() << "[WallpaperRuler::getAppSettings]";
	return this->appSettings;
}

AppLocalization* WallpaperRuler::getAppLocalization() {
	qDebug() << "[WallpaperRuler::getAppLocalization]";
	return this->appLocalization;
}

ImageEditor* WallpaperRuler::getImageEditor(){
	qDebug() << "[WallpaperRuler::getImageEditor]";
	return this->imageEditor;
}

ImageGridDataProvider* WallpaperRuler::getImageGridDataProvider(){
	qDebug() << "[WallpaperRuler::getImageGridDataProvider]";
	return this->imageGridDataProvider;
}

CameraManager* WallpaperRuler::getCameraManager(){
	qDebug() << "[WallpaperRuler::getCameraManager]";
	return this->cameraManager;
}

ScreenSize* WallpaperRuler::getScreenSize(){
	qDebug() << "[WallpaperRuler::getScreenSize]";
	return this->screenSize;
}
