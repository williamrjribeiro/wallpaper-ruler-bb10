/*
 * ImageEditor.cpp
 *
 *  Created on: Jul 14, 2013
 *      Author: marcogrimaudo
 */

#include "ImageEditor.h"
#include <QByteArray>
#include <QDebug>

#include <QtGui/QImage>
#include <QtGui/QImageReader>

#include <bb/cascades/Image>

ImageEditor::ImageEditor(QObject *parent)
	:QObject(parent)
{

}

ImageEditor::~ImageEditor() {
}

QString ImageEditor::processImage(const QString &qurl, const double scale, const double translationX, const double translationY, const double rotation){
	QString imagePath = qurl;
	imagePath.replace("file://","",Qt::CaseInsensitive);
	QImageReader reader(imagePath);
	QImage image = reader.read();
	qDebug() << "[ImageEditor::processImage] scale: " << scale << ", translationX: " << translationX << ", translationY: " << translationY << ", rotation: " << rotation;
	double factor = 1.0;
	if(image.width() > image.height())
	{
		factor = 720.0/image.width();
	}else
	{
		factor = 720.0/image.height();
	}
	QTransform transform;
	//transform.translate(translationX,translationY);
	transform.scale(factor*scale,factor*scale);
	transform.rotate(rotation);
	QImage tranformedImage = image.transformed(transform,Qt::SmoothTransformation);
	QImage croppedImage = tranformedImage.copy( 0 - translationX, 0 - translationY, 720, 720);
	QString workingDir = QDir::currentPath();
	bool t;
	QString imageName = decideImageName();
	t = croppedImage.save(workingDir + "/shared/photos/wappy/wappy-" + imageName + ".jpg","JPG");
	qDebug() << t;
	if(t==true){
		return workingDir + "/shared/photos/wappy/wappy-" + imageName + ".jpg";
	}
	else{
		return "";
	}
}

QString ImageEditor::decideImageName(){
	QString workingDir = QDir::currentPath();
	QStringList filters;
	filters << "*.jpeg" << "*.png" << "*.jpg";
	QDir dir(workingDir + "/shared/photos/wappy/");
	bool exist = dir.mkdir(workingDir + "/shared/photos/wappy/");
	dir.setFilter(QDir::Files | QDir::Dirs | QDir::NoDot | QDir::NoDotDot);
	dir.setNameFilters(filters);

	QDirIterator it(dir);
	int maxNumber = 0;
	while(it.hasNext()) {
		it.next();
		QString filename = it.fileName();
		if(filename.startsWith("wappy-",Qt::CaseInsensitive) && filename.endsWith(".jpg",Qt::CaseInsensitive)){
			bool ok;
			int n = (int)filename.mid(6,3).toInt(&ok,10);
			if(ok == true){
				maxNumber = n > maxNumber ? n : maxNumber;
			}
		}
	}
	if (maxNumber > 0){
		return QString("%1").arg(maxNumber+1, 3, 10, QChar('0')).toUpper();
	}
	return "001";
}
