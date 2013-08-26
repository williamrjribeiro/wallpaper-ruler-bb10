// Default empty project template
#ifndef WallpaperRuler_HPP_
#define WallpaperRuler_HPP_

#include <QObject>
#include <QTranslator>

#include <bb/cascades/Application>

#include <bb/system/InvokeManager>
#include <bb/system/InvokeRequest>
#include <bb/system/CardResizeMessage>

#include "controller/AppSettings.hpp"
#include "controller/AppLocalization.h"
#include "controller/CameraManager.hpp"
#include "ImageEditor.h"
#include "model/ImageGridDataProvider.h"
#include "ScreenSize.hpp"

/*!
 * @brief Application pane object
 *
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class WallpaperRuler : public QObject
{
    Q_OBJECT

public:
    WallpaperRuler(bb::cascades::Application *app);
    virtual ~WallpaperRuler() {}

    AppSettings* getAppSettings();
    AppLocalization* getAppLocalization();
    ImageEditor* getImageEditor();
    ImageGridDataProvider* getImageGridDataProvider();
    CameraManager* getCameraManager();
    ScreenSize* getScreenSize();

public Q_SLOTS:
// Invoaction
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
    CameraManager* cameraManager;
    ScreenSize* screenSize;
    bb::system::InvokeManager* m_invokeManager;
};
#endif /* WallpaperRuler_HPP_ */
