/*
 * AppLocalization.cpp
 *
 *  Created on: Feb 3, 2013
 *      Author: williamrjribeiro
 */
#include <QDebug>
#include <bb/cascades/Application>

#include "AppLocalization.h"

using namespace wpr::controller;
using namespace bb::cascades;

AppLocalization::AppLocalization(QTranslator *translator) {
	qDebug() << "[AppLocalization::AppLocalization]";
	mTranslator = translator;
}

bool AppLocalization::loadTranslator(const QString languageName){
	qDebug() << "[AppLocalization::loadTranslator] languageName: " << languageName;

	QString filename = QString( "WallpaperRuler_%1" ).arg( languageName );

	bool ok = this->mTranslator->load(filename, "app/native/qm");

	if (ok) {
		Application::instance()->removeTranslator( mTranslator );
		Application::instance()->installTranslator( mTranslator );
	}
	else{
		qDebug() << "[AppLocalization::loadTranslator] Unable to install QTranslator! filename: " << filename;
	}
	return ok;
}

