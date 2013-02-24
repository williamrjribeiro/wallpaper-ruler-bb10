// Default empty project template
#ifndef WallpaperRuler_HPP_
#define WallpaperRuler_HPP_

#include <QObject>
#include <QTranslator>

#include "controller/AppSettings.hpp"
#include "controller/AppLocalization.h"

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

public Q_SLOTS:
	void onThumbnail();

private:
	void initialize(QTranslator *translator);

    AppSettings* appSettings;
    AppLocalization* appLocalization;
};
#endif /* WallpaperRuler_HPP_ */