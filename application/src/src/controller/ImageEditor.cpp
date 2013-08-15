/*
 * ImageEditor.cpp
 *
 *  Created on: Jul 14, 2013
 *      Author: marcogrimaudo
 */

#include "ImageEditor.h"
#include <QByteArray>
#include <QDebug>

#include <QtGui/QImageReader>

#include <bb/cascades/Image>
#include <math.h>

ImageEditor::ImageEditor(QObject *parent)
	:QObject(parent)
{

}

ImageEditor::~ImageEditor() {
}

QImage ImageEditor::readImage(const QString &qurl){
	qDebug() << "[ImageEditor::readImage] qurl: " << qurl;
	QString imagePath = qurl;
	imagePath.replace("file://","",Qt::CaseInsensitive);
	QImageReader reader(imagePath);
	return reader.read();
}

QString ImageEditor::processImage(const QString &qurl, const double scale, const double translationX, const double translationY, const double rotation,
		 const int screenWidth, const int screenHeight){
	qDebug() << "[ImageEditor::processImage] scale: "<<scale<<", translationX: "<<translationX<<", translationY: "<<translationY<<", rotation: "<<rotation
				<<", screenWidth: "<<screenWidth<<", screenHeight: "<<screenHeight;

	QString workingDir = QDir::currentPath();
	QString imageName = decideImageName();
	QImage original = this->readImage(qurl);
	// scale it to the device height (shrink or grow) maintaining the aspect ratio of the image
	original = original.scaledToHeight(screenHeight,Qt::SmoothTransformation);

	qDebug() << "[ImageEditor::processImage] scaledToHeight.width: "<<original.width();

	// create a new image with the size of the screen so we can draw on it
	QImage created (QSize(screenWidth,screenHeight), QImage::Format_RGB32);

	// calculate the vertical middle of the image
	const double sx = ( (original.width() - screenWidth) * 0.5 ) - translationX;
	const double hiw = original.width() * 0.5;
	const double hih = original.height() * 0.5;
	double ratio = scale;

	qDebug() << "[ImageEditor::processImage] sx: " << sx << ", hiw: " << hiw<< ", hih: " << hih;
	if( hiw != hih){
		const double oar = hiw / hih;					// original aspect ratio
		ratio = scale / oar;
		qDebug() << "[ImageEditor::processImage] oar: " << QString::number( oar, 'd', 3 )<< ", ratio: " << QString::number( ratio, 'd', 3 );
	}

	// Create Painter so we can draw the original image on the created one
	QPainter painter(&created);

	QTransform ptrans;
	ptrans.translate(-sx,translationY);
	ptrans.translate(hiw,hih);
	ptrans.scale(ratio,ratio);
	ptrans.rotate(rotation);
	ptrans.translate(-hiw,-hih);

	painter.setTransform(ptrans);
	//painter.drawImage(rect,original);
	painter.drawImage(original.rect(),original);

	// save the modified/painted image to the device
	created.save(workingDir + "/shared/photos/wappy/wappy-" + imageName+".jpg","JPG");

	// return the path of the saved file so we can set it as wallpaper
	return workingDir + "/shared/photos/wappy/wappy-" + imageName+".jpg";
}

QImage ImageEditor::applyTransformAndSave(const QImage &image, const QTransform &trans,const QString &name){
	QImage transformed = image.transformed(trans,Qt::SmoothTransformation);
	transformed.save( QDir::currentPath() + "/shared/photos/wappy/wappy-"+name+".jpg","JPG");
	return transformed;
}

QString ImageEditor::decideImageName(){
	QString workingDir = QDir::currentPath();
	QStringList filters;
	filters << "*.jpeg" << "*.png" << "*.jpg";

	QDir dir(workingDir + "/shared/photos/wappy/");
	dir.mkdir(workingDir + "/shared/photos/wappy/");
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
