/*
 * AppLocalization.h
 *
 *  Created on: Feb 3, 2013
 *      Author: williamrjribeiro
 */

#ifndef APPLOCALIZATION_H_
#define APPLOCALIZATION_H_

#include <QObject>
#include <QTranslator>

#include <bb/cascades/LocaleHandler>

class AppLocalization: public QObject {

	Q_OBJECT

public:
	AppLocalization(QObject *parent = 0);
	virtual ~AppLocalization(){};

	/*
	 * Allows the current locale to be retrieved from QML
	 *
	 * @return the current locale
	 */
	Q_INVOKABLE
	QString getCurrentLocale();

private slots:
	void onSystemLanguageChanged();
private:
	QTranslator *m_translator;
	bb::cascades::LocaleHandler* m_localeHandler;
	QString m_currentLocale;
};

#endif /* APPLOCALIZATION_H_ */
