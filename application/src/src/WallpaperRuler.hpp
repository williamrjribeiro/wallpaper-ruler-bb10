// Default empty project template
#ifndef WallpaperRuler_HPP_
#define WallpaperRuler_HPP_

#include <QObject>
#include <QTranslator>

#include "controller/AppSettings.hpp"
#include "controller/AppLocalization.h"
#include "controller/CameraManager.hpp"
#include "ImageEditor.h"
#include "model/ImageGridDataProvider.h"

/*!
 * @brief Application pane object
 *
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class WallpaperRuler : public QObject
{
    Q_OBJECT

public:
    WallpaperRuler(QTranslator *translator, QObject *parent = 0);
    virtual ~WallpaperRuler() {}

    AppSettings* getAppSettings();
    AppLocalization* getAppLocalization();
    ImageEditor* getImageEditor();
    ImageGridDataProvider* getImageGridDataProvider();
    CameraManager* getCameraManager();

private Q_SLOTS:
	void onActiveFrame();
	void onAboutToQuit();

private:
    AppSettings* appSettings;
    AppLocalization* appLocalization;
    ImageEditor* imageEditor;
    ImageGridDataProvider* imageGridDataProvider;
    CameraManager* cameraManager;
};
#endif /* WallpaperRuler_HPP_ */
