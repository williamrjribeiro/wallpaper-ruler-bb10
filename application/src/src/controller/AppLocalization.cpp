/*
 * AppLocalization.cpp
 *
 *  Created on: Feb 3, 2013
 *      Author: williamrjribeiro
 */
#include <QDebug>
#include <QCoreApplication>

#include <bb/cascades/Application>

#include "AppLocalization.h"

using namespace bb::cascades;

AppLocalization::AppLocalization(QObject *parent)
	:QObject(parent)
	, m_translator(new QTranslator(this))
	, m_localeHandler(new LocaleHandler(this))
{
	qDebug() << "[AppLocalization::AppLocalization]";

	bool ok = QObject::connect(m_localeHandler, SIGNAL(systemLanguageChanged()), this,
			SLOT(onSystemLanguageChanged()));
	Q_UNUSED(ok);
	Q_ASSERT_X(ok,"[AppLocalization::AppLocalization]", "connect systemLanguageChanged failed");

	// initial load
	onSystemLanguageChanged();
}

void AppLocalization::onSystemLanguageChanged()
{
	qDebug() << "[AppLocalization::onSystemLanguageChanged]";

	QCoreApplication::instance()->removeTranslator(m_translator);

	// Initiate, load and install the application translation files.
	m_currentLocale = QLocale().name();
	QString file_name = QString("WallpaperRuler_%1").arg(m_currentLocale);
	if (m_translator->load(file_name, "app/native/qm")) {
		QCoreApplication::instance()->installTranslator(m_translator);
	}
}

QString AppLocalization::getCurrentLocale()
{
	return m_currentLocale;
}

