/*
 * ImageEditor.h
 *
 *  Created on: Jul 14, 2013
 *      Author: marcogrimaudo
 */

#ifndef IMAGEEDITOR_H_
#define IMAGEEDITOR_H_

#include <QObject>
#include <QString>
#include <QtGui/QImage>
#include <QtGui/QTransform>

class ImageEditor: public QObject {

	Q_OBJECT

public:
	ImageEditor(QObject *parent = 0);
	virtual ~ImageEditor();

	Q_INVOKABLE QString processImage(const QString &qurl,
										 const double scale,
										 const double translationX,
										 const double translationY,
										 const double rotation,
										 const int screenWidth,
										 const int screenHeight);

	QString decideImageName();

private:
	QImage readImage(const QString &qurl);
	QImage applyTransformAndSave(const QImage &image, const QTransform &trans,const QString &name);
};

#endif /* IMAGEEDITOR_H_ */
