// Default empty project template
#ifndef WallpaperRuler_HPP_
#define WallpaperRuler_HPP_

#include <QObject>
#include <QTranslator>
#include <bb/cascades/QmlDocument>

#include "controller/AppSettings.hpp"
#include "controller/AppLocalization.h"

namespace bb { namespace cascades { class Application; }}

using namespace bb::cascades;

/*!
 * @brief Application pane object
 *
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class WallpaperRuler : public QObject
{
    Q_OBJECT

public:
    WallpaperRuler(bb::cascades::Application *app, QTranslator *translator);
    virtual ~WallpaperRuler() {}

    int initialize(QTranslator *translator);
    wpr::controller::AppSettings* getAppSettings();
    wpr::controller::AppLocalization* getAppLocalization();
    Application* getApplication();

public Q_SLOTS:
	void onThumbnail();

private:
    wpr::controller::AppSettings* appSettings;
    wpr::controller::AppLocalization* appLocalization;
    QmlDocument *qml;
    Application *app;
};
#endif /* WallpaperRuler_HPP_ */
