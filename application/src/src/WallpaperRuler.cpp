#include "WallpaperRuler.hpp"

#include <QDebug>
#include <bb/cascades/Application>

using namespace bb::cascades;

WallpaperRuler::WallpaperRuler(QTranslator *translator, QObject *parent)
	: QObject(parent)
{

	qDebug() << "[WallpaperRuler::WallpaperRuler]";

	this->initialize(translator);

	// This signal is fired when the application is minimized (active frame)
	bool ok = connect( Application::instance(), SIGNAL(thumbnail()), this, SLOT(onThumbnail()));
	if (!ok) {
		qDebug() << "connect thumbnail failed";
	}
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
}

// triggered if Application was sent to back
void WallpaperRuler::onThumbnail() {
	// TODO set Cover()
	qDebug() << "[WallpaperRuler::onThumbnail] Application shrinks to thumbnail";
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
