/*
 * AppSettings.cpp
 *
 *  Created on: Feb 3, 2013
 *      Author: WilliamRafael
 */

#include "AppSettings.hpp"

#include <QDebug>
#include <QCoreApplication>
#include <QSettings>
#include <QVariant>

const QString AppSettings::APP_LANG = "APP_LANG";

AppSettings::AppSettings(QObject *parent)
	: QObject(parent)
{

	qDebug() << "[AppSettings::AppSettings]";

	// Set the application organization and name, which is used by QSettings
	// when saving values to the persistent store.
	QCoreApplication::setOrganizationName("Will Thrill");
	QCoreApplication::setApplicationName("Wallpaper Ruler");
}

QString AppSettings::getValueFor(const QString& settingName, const QString& defaultValue) {
	qDebug() << "[AppSettings::getValueFor] settingName: " << settingName << " defaultValue: " << defaultValue;

	// get the reference to the global QSettings object
	QSettings settings;

	// get the value of the key
	QVariant value = settings.value(settingName);

	// If no value has been saved, return the default value.
	if( value.isNull()){
		return defaultValue;
	}

	// Otherwise, return the value stored in the settings object.
	return value.toString();
}

void AppSettings::saveValueFor(const QString& settingName, const QString& inputValue) {
	qDebug() << "[AppSettings::saveValueFor] settingName: " << settingName << " inputValue: " << inputValue;

	QSettings settings;
	settings.setValue(settingName,QVariant(inputValue));
}

