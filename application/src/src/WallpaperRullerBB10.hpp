// Default empty project template
#ifndef WallpaperRullerBB10_HPP_
#define WallpaperRullerBB10_HPP_

#include <QObject>
#include <bb/cascades/QmlDocument>

#include "controller/AppSettings.hpp"

namespace bb { namespace cascades { class Application; }}

using namespace bb::cascades;

/*!
 * @brief Application pane object
 *
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class WallpaperRullerBB10 : public QObject
{
    Q_OBJECT

public:
    WallpaperRullerBB10(bb::cascades::Application *app);
    virtual ~WallpaperRullerBB10() {}

    int initialize();
    wpr::controller::AppSettings* getAppSettings();

private:
    wpr::controller::AppSettings* appSettings;
    QmlDocument *qml;
};
#endif /* WallpaperRullerBB10_HPP_ */
