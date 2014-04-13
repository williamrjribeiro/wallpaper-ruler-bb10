#include "MyApplication.hpp"
#include "ImageLoader.h"

#include <QDebug>
#include <QDateTime>
#include <QDir>

#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>

using namespace bb::cascades;
using namespace bb::system;

MyApplication::MyApplication( Application *app )
	: QObject(app)
	, appSettings(new AppSettings(this))
	, appLocalization(new AppLocalization(this))
	, imageEditor(new ImageEditor(this))
	, imageGridDataProvider(NULL)
	, gifsGridDataProvider(NULL)
	, cameraManager(NULL)
	, screenSize(new ScreenSize(this))
	, m_invokeManager(new InvokeManager(this))
{

	// Deal with application startup first in order to create only the necessary Objects
	bool ok = connect(m_invokeManager,
				SIGNAL(invoked(const bb::system::InvokeRequest&)), this,
				SLOT(handleInvoke(const bb::system::InvokeRequest&)));

	Q_UNUSED(ok);
	Q_ASSERT_X(ok,"[MyApplication::MyApplication]", "connect handleInvoke failed");

	ok = connect(m_invokeManager,
			SIGNAL(cardResizeRequested(const bb::system::CardResizeMessage&)),
			this, SLOT(handleCardResize(const bb::system::CardResizeMessage&)));

	Q_ASSERT_X(ok,"[MyApplication::MyApplication]", "connect handleCardResize failed");

	ok = connect(m_invokeManager,
			SIGNAL(cardPooled(const bb::system::CardDoneMessage&)), this,
			SLOT(handleCardPooled(const bb::system::CardDoneMessage&)));

	Q_ASSERT_X(ok,"[MyApplication::MyApplication]", "connect handleCardPooled failed");

	// This signal is fired when the application is minimized (active frame)
	ok = connect( Application::instance(), SIGNAL(thumbnail()), this, SLOT(handleActiveFrame()));

	Q_ASSERT_X(ok,"[MyApplication::MyApplication]", "connect thumbnail failed");

	ok = connect( Application::instance(), SIGNAL(aboutToQuit()), this, SLOT(handleAboutToQuit()));

	Q_ASSERT_X(ok,"[MyApplication::MyApplication]", "connect aboutToQuit failed");

	qDebug() << "[MyApplication::MyApplication] m_lastClosed: " << this->appSettings->lastClosed();

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
			break;
	}

	// Register custom type to QML
	qmlRegisterType<ImageLoader>();
}

void MyApplication::handleInvoke(const InvokeRequest& request)
{
	qDebug() << "[MyApplication::handleInvoke] Action: "<<request.action()<<", Mime: "<<request.mimeType()<<", URI:" << request.uri()
			<<"Data:" << request.data() << ", m_invokeManager.startupMode: " << m_invokeManager->startupMode();

	if (!request.uri().isEmpty()) {
		emit invokedWith(request.uri().toString());
	}
}

/**
 * Inform the Invocation Framework that the Card is done.
 * @param bool success: true if the image provided was set as wallpaper, false otherwise.
 */
void MyApplication::cardDone(QString reason, QString message)
{
	qDebug() << "[MyApplication::cardDone] reason: " << reason << ", message: " << message;
	// Assemble and send message
	CardDoneMessage cdm;
	cdm.setData(message);
	cdm.setDataType("text/plain");
	cdm.setReason(reason);
	m_invokeManager->sendCardDone(cdm);
}

void MyApplication::cardCanceled(QString reason)
{
	qDebug() << "[MyApplication::cardCanceled] reason: "<<reason;
}

void MyApplication::initFullApplication(Application *app)
{
	qDebug() << "[MyApplication::initFullApplication]";

	// Only look for this type of images
	QStringList filters;
	filters << "*.jpeg" << "*.png" << "*.jpg" << "*.bmp";
	this->imageGridDataProvider = new ImageGridDataProvider(filters, this);

	QStringList gifsFilter;
	gifsFilter << "*.gif";
	this->gifsGridDataProvider = new ImageGridDataProvider(gifsFilter, this);

	this->cameraManager = new CameraManager(this->imageGridDataProvider,this);

	// create scene document from main.qml asset
	// set parent to created document to ensure it exists for the whole application lifetime
	QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

	// Create the ScreenSize utility
	qml->setContextProperty("_screenSize", this->screenSize);

	// Make the AppSettings instance available to QML as _appSettings
	qml->setContextProperty("_appSettings", this->appSettings);

	// Make the AppLocalization instance available to QML as _appLocalization
	qml->setContextProperty("_appLocalization", this->appLocalization);

	// Make the CameraManager instance available to QML as _cameraManager
	qml->setContextProperty("_cameraManager", this->cameraManager);

	// Make the ImageEditor instance used for saving an edited image
	qml->setContextProperty("_imageEditor", this->imageEditor);

	// Make the Model instance, used for creating the IIC, available to QML as _imageGridDataProvider
	qml->setContextProperty("_imageGridDataProvider", this->imageGridDataProvider);

	// Make the Model instance, used for creating the IGC, available to QML as _gifsGridDataProvider
	qml->setContextProperty("_gifsGridDataProvider", this->gifsGridDataProvider);

	QString m_homeDir = QDir::homePath() + "/../app/native";
	QmlDocument::defaultDeclarativeEngine()->rootContext()->setContextProperty("homeDir", m_homeDir);

	// create root object for the UI
	AbstractPane *root = qml->createRootObject<AbstractPane>();

	// set created root object as a scene
	app->setScene(root);
}

void MyApplication::initCardApplication(Application *app)
{
	qDebug() << "[MyApplication::initCardApplication]";

	// create scene document from main.qml asset
	// set parent to created document to ensure it exists for the whole application lifetime
	QmlDocument *qml = QmlDocument::create("asset:///MultipleFramesEditor.qml").parent(this);

	// Make the main application instance available to QML as _screenSize
	qml->setContextProperty("_wpr", this);

	// Make the ScreenSize utility instance available to QML as _screenSize
	qml->setContextProperty("_screenSize", this->screenSize);

	// Make the AppSettings instance available to QML as _appSettings
	qml->setContextProperty("_appSettings", this->appSettings);

	// Make the AppLocalization instance available to QML as _appLocalization
	qml->setContextProperty("_appLocalization", this->appLocalization);

	// Make the ImageEditor instance used for saving an edited image
	qml->setContextProperty("_imageEditor", this->imageEditor);

	// create root object for the UI
	AbstractPane *root = qml->createRootObject<AbstractPane>();

	// set created root object as a scene
	app->setScene(root);
}

// triggered when the user closes the Application
void MyApplication::handleAboutToQuit()
{

	// Save the date and time before closing so that we can figure out when to show the Long Press Tutoria image
	QString quitDate = QDateTime::currentDateTime().toString(AppSettings::APP_DATE_FORMAT);
	qDebug() << "[MyApplication::handleAboutToQuit] Exiting application. quitDate" << quitDate;
	this->appSettings->saveValueFor( AppSettings::APP_LAST_CLOSED, quitDate);

	// Explicity delete the DataProvider so that bb::cascades::ImageData is released
	if(imageGridDataProvider != NULL){
		imageGridDataProvider->clearOldThumbs();
		imageGridDataProvider->disconnect();
		imageGridDataProvider->deleteLater();
	}
}

void MyApplication::handleCardResize(const CardResizeMessage& message)
{
	qDebug() << "[MyApplication::handleCardResize] message.width: " << message.width();
}

void MyApplication::handleCardPooled(const CardDoneMessage& message)
{
	qDebug() << "[MyApplication::handleCardPooled] message.reason: " << message.reason();
}

// triggered if Application is minimized (Active Frame)
void MyApplication::handleActiveFrame()
{
	qDebug() << "[MyApplication::handleActiveFrame] Application is now an Active Frame (minimized)";
}

AppSettings* MyApplication::getAppSettings()
{
	qDebug() << "[MyApplication::getAppSettings]";
	return this->appSettings;
}

AppLocalization* MyApplication::getAppLocalization()
{
	qDebug() << "[MyApplication::getAppLocalization]";
	return this->appLocalization;
}

ImageEditor* MyApplication::getImageEditor()
{
	qDebug() << "[MyApplication::getImageEditor]";
	return this->imageEditor;
}

ImageGridDataProvider* MyApplication::getImageGridDataProvider()
{
	qDebug() << "[MyApplication::getImageGridDataProvider]";
	return this->imageGridDataProvider;
}

CameraManager* MyApplication::getCameraManager()
{
	qDebug() << "[MyApplication::getCameraManager]";
	return this->cameraManager;
}

ScreenSize* MyApplication::getScreenSize()
{
	qDebug() << "[MyApplication::getScreenSize]";
	return this->screenSize;
}

InvokeManager* MyApplication::getInvokeManager()
{
	return this->m_invokeManager;
}
