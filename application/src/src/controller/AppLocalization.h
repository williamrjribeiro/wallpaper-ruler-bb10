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

class AppLocalization: public QObject {

	Q_OBJECT

public:
	AppLocalization(QTranslator *translator, QObject *parent = 0);
	virtual ~AppLocalization(){};

	Q_INVOKABLE
	bool loadTranslator(const QString);

private:
	QTranslator *mTranslator;
};

#endif /* APPLOCALIZATION_H_ */
