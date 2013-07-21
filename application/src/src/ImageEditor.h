/*
 * ImageEditor.h
 *
 *  Created on: Jul 14, 2013
 *      Author: marcogrimaudo
 */

#ifndef IMAGEEDITOR_H_
#define IMAGEEDITOR_H_

#include <QObject>
#include <QByteArray>
#include <bb/cascades/Image>
#include <QImage>
#include <QString>
#include <QtGui/QImageReader>

class ImageEditor: public QObject {

	Q_OBJECT

public:
	ImageEditor();
	virtual ~ImageEditor();

	Q_INVOKABLE QString processImage(const QString &qurl, const double scale, const double translationX, const double translationY, const double rotation);

	QString decideImageName();
};

#endif /* IMAGEEDITOR_H_ */
