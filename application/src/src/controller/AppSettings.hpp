/*
 * AppSettings.h
 *
 *  Created on: Feb 3, 2013
 *      Author: williamrjribeiro
 */

#ifndef APPSETTINGS_HPP_
#define APPSETTINGS_HPP_

#include <QObject>

class AppSettings: public QObject {

	Q_OBJECT

public:
	// The Application language setting.
	static const QString APP_LANG;

	AppSettings(QObject *parent = 0);
	~AppSettings(){};

	/* Invokable functions that we can call from QML*/

	/**
	 * This Invokable function gets a value from the QSettings,
	 * if that value does not exist in the QSettings database, the default value is returned.
	 *
	 * @param settingName Index path to the item
	 * @param defaultValue Used to create the data in the database when adding
	 * @return If the objectName exists, the value of the QSettings object is returned.
	 *         If the objectName doesn't exist, the default value is returned.
	 */
	Q_INVOKABLE
	QString getValueFor(const QString &settingName, const QString &defaultValue);

	/**
	 * This function sets a value in the QSettings database. This function should to be called
	 * when a data value has been updated from QML
	 *
	 * @param settingName Index path to the item
	 * @param inputValue new value to the QSettings database
	 */
	Q_INVOKABLE
	void saveValueFor(const QString &settingName, const QString &inputValue);
};
#endif /* APPSETTINGS_HPP_ */
