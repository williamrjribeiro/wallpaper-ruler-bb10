#include "WallpaperRuler.hpp"
#include "ImageLoader.h"

#include <QDebug>
#include <QDateTime>

#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>

using namespace bb::cascades;
using namespace bb::system;

WallpaperRuler::WallpaperRuler( Application *app )
	: QObject(app)
	, appSettings(new AppSettings(this))
	, appLocalization(NULL)
	, imageEditor(new ImageEditor(this))
	, imageGridDataProvider(NULL)
	, cameraManager(NULL)
	, screenSize(new ScreenSize(this))
	, m_invokeManager(new InvokeManager(this))
{

	// Deal with application startup first in order to create only the necessary Objects
	bool ok = connect(m_invokeManager,
				SIGNAL(invoked(const bb::system::InvokeRequest&)), this,
				SLOT(handleInvoke(const bb::system::InvokeRequest&)));
	if (!ok) {
		qDebug() << "[WallpaperRuler::WallpaperRuler] connect handleInvoke failed";
	}
	ok = connect(m_invokeManager,
			SIGNAL(cardResizeRequested(const bb::system::CardResizeMessage&)),
			this, SLOT(handleCardResize(const bb::system::CardResizeMessage&)));
	if (!ok) {
		qDebug() << "[WallpaperRuler::WallpaperRuler] connect handleCardResize failed";
	}
	ok = connect(m_invokeManager,
			SIGNAL(cardPooled(const bb::system::CardDoneMessage&)), this,
			SLOT(handleCardPooled(const bb::system::CardDoneMessage&)));
	if (!ok) {
		qDebug() << "[WallpaperRuler::WallpaperRuler] connect handleCardPooled failed";
	}

	// This signal is fired when the application is minimized (active frame)
	ok = connect( Application::instance(), SIGNAL(thumbnail()), this, SLOT(handleActiveFrame()));
	if (!ok) {
		qDebug() << "[WallpaperRuler::WallpaperRuler] connect thumbnail failed";
	}

	ok = connect( Application::instance(), SIGNAL(aboutToQuit()), this, SLOT(handleAboutToQuit()));
	if (!ok) {
		qDebug() << "[WallpaperRuler::WallpaperRuler] connect aboutToQuit failed";
	}

	qDebug() << "[WallpaperRuler::WallpaperRuler] m_lastClosed: " << this->appSettings->lastClosed();

	switch( m_invokeManager->startupMode() ) {
		// Launched as full application from home screen
		case ApplicationStartupMode::LaunchApplication:
			this->initFullApplication(app);
			break;

		// invoked as a Card from another app: just load the minimal objects and show MFE
		case ApplicationStartupMode::InvokeCard:
			this->initCardApplication(app);
			break;
		default:
			// What app is it and how did it get here?
			break;
	}

	// Register custom type to QML
	qmlRegisterType<ImageLoader>();

	// read the App Language Property
	//QString appLang = this->appSettings->getValueFor( AppSettings::APP_LANG, QString("en") );

	// create the AppLocalization instance
	//this->appLocalization = new AppLocalization(translator, this);
	//this->appLocalization->loadTranslator(appLang);

}

void WallpaperRuler::handleInvoke(const InvokeRequest& request){
	qDebug() << "[WallpaperRuler::handleInvoke] Action: "<<request.action()<<", Mime: "<<request.mimeType()<<", URI:" << request.uri()
			<<"Data:" << request.data() << ", m_invokeManager.startupMode: " << m_invokeManager->startupMode();

}

void WallpaperRuler::initFullApplication(Application *app) {
	qDebug() << "[WallpaperRuler::initFullApplication]";

	this->imageGridDataProvider = new ImageGridDataProvider(this);
	this->cameraManager = new CameraManager(this->imageGridDataProvider,this);

	// create scene document from main.qml asset
	// set parent to created document to ensure it exists for the whole application lifetime
	QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

	// Create the ScreenSize utility
	qml->setContextProperty("_screenSize", this->screenSize);

	// Make the AppSettings instance available to QML as _appSettings
	qml->setContextProperty("_appSettings", this->appSettings);

	// Make the AppLocalization instance available to QML as _appLocalization
	//qml->setContextProperty("_appLocalization", wpr->getAppLocalization());

	// Make the CameraManager instance available to QML as _cameraManager
	qml->setContextProperty("_cameraManager", this->cameraManager);

	// Make the ImageEditor instance used for saving an edited image
	qml->setContextProperty("_imageEditor", this->imageEditor);

	// Make the Model instance, used for creating the IIC, available to QML as _imageGridDataProvider
	qml->setContextProperty("_imageGridDataProvider", this->imageGridDataProvider);

	// create root object for the UI
	AbstractPane *root = qml->createRootObject<AbstractPane>();

	// set created root object as a scene
	app->setScene(root);

}

void WallpaperRuler::initCardApplication(Application *app) {
	qDebug() << "[WallpaperRuler::initCardApplication]";

	// create scene document from main.qml asset
	// set parent to created document to ensure it exists for the whole application lifetime
	QmlDocument *qml = QmlDocument::create("asset:///MultipleFramesEditor.qml").parent(this);

	// Create the ScreenSize utility
	qml->setContextProperty("_screenSize", this->screenSize);

	// Make the AppSettings instance available to QML as _appSettings
	qml->setContextProperty("_appSettings", this->appSettings);

	// Make the AppLocalization instance available to QML as _appLocalization
	//qml->setContextProperty("_appLocalization", wpr->getAppLocalization());

	// Make the ImageEditor instance used for saving an edited image
	qml->setContextProperty("_imageEditor", this->imageEditor);

	// create root object for the UI
	AbstractPane *root = qml->createRootObject<AbstractPane>();

	// set created root object as a scene
	app->setScene(root);
}

// triggered when the user closes the Application
void WallpaperRuler::handleAboutToQuit() {

	// Save the date and time before closing so that we can figure out when to show the Long Press Tutoria image
	QString quitDate = QDateTime::currentDateTime().toString(AppSettings::APP_DATE_FORMAT);
	qDebug() << "[WallpaperRuler::handleAboutToQuit] Exiting application. quitDate" << quitDate;
	this->appSettings->saveValueFor( AppSettings::APP_LAST_CLOSED, quitDate);

	// Explicity delete the DataProvider so that bb::cascades::ImageData is released
	if(imageGridDataProvider != NULL){
		imageGridDataProvider->disconnect();
		imageGridDataProvider->deleteLater();
	}
}

void WallpaperRuler::handleCardResize(const CardResizeMessage& message){
	qDebug() << "[WallpaperRuler::handleCardResize] message.width: " << message.width();
}

void WallpaperRuler::handleCardPooled(const CardDoneMessage& message){
	qDebug() << "[WallpaperRuler::handleCardPooled] message.reason: " << message.reason();
}

// triggered if Application is minimized (Active Frame)
void WallpaperRuler::handleActiveFrame() {
	qDebug() << "[WallpaperRuler::handleActiveFrame] Application is now an Active Frame (minimized)";
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
