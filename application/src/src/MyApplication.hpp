// Default empty project template
#ifndef MyApplication_HPP_
#define MyApplication_HPP_

#include <QObject>
#include <QTranslator>

#include <bb/cascades/Application>

#include <bb/system/InvokeManager>
#include <bb/system/InvokeRequest>
#include <bb/system/CardResizeMessage>

#include "model/ImageGridDataProvider.h"
#include "controller/AppSettings.hpp"
#include "controller/AppLocalization.h"
#include "controller/CameraManager.hpp"
#include "controller/ImageEditor.h"
#include "controller/ScreenSize.hpp"

/*!
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class MyApplication : public QObject
{
    Q_OBJECT

public:
    MyApplication(bb::cascades::Application *app);
    virtual ~MyApplication() {}

    AppSettings* getAppSettings();
    AppLocalization* getAppLocalization();
    ImageEditor* getImageEditor();
    ImageGridDataProvider* getImageGridDataProvider();
    CameraManager* getCameraManager();
    ScreenSize* getScreenSize();
    bb::system::InvokeManager* getInvokeManager();

signals:
	void invokedWith(const QString filePath);

public Q_SLOTS:
	// This method is invoked to notify the invocation system that the action has been done successfully
	void cardDone(QString, QString);
	// This method is invoked to notify the invocation system that the action has been done without success
	void cardCanceled(QString reason);

private Q_SLOTS:
	void handleActiveFrame();
	void handleAboutToQuit();
	void handleInvoke(const bb::system::InvokeRequest&);
	void handleCardResize(const bb::system::CardResizeMessage&);
	void handleCardPooled(const bb::system::CardDoneMessage&);

private:
	void initFullApplication(bb::cascades::Application *app);
	void initCardApplication(bb::cascades::Application *app);

    AppSettings* appSettings;
    AppLocalization* appLocalization;
    ImageEditor* imageEditor;
    ImageGridDataProvider* imageGridDataProvider;
    ImageGridDataProvider* gifsGridDataProvider;
    CameraManager* cameraManager;
    ScreenSize* screenSize;
    bb::system::InvokeManager* m_invokeManager;
};
#endif /* MyApplication_HPP_ */
