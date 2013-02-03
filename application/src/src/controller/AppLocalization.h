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

namespace wpr {
namespace controller {

class AppLocalization: public QObject {

	Q_OBJECT

public:
	AppLocalization(QTranslator *translator);
	virtual ~AppLocalization(){};

	Q_INVOKABLE
	bool loadTranslator(const QString);

private:
	QTranslator *mTranslator;
};

} // namespace controller
} // namespace wpr
#endif /* APPLOCALIZATION_H_ */
