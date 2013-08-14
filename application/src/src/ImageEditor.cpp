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

	// Load the original image
	QImage original = this->readImage(qurl);

	qDebug() << "[ImageEditor::processImage] original.width: "<<original.width();

	// scale it to the device height
	original = original.scaledToHeight(screenHeight,Qt::SmoothTransformation);

	qDebug() << "[ImageEditor::processImage] scaledToHeight.width: "<<original.width();

	//double factor = original.width() > original.height() ? screenHeight / original.width() : screenHeight / original.height();

	// create a new image with the size of the screen so we can draw on it
	QImage created (QSize(screenWidth,screenHeight), QImage::Format_RGB32);

	// calculate the vertical middle of the image
	double sx = ( (original.width() - screenWidth) * 0.5 ) - translationX;
	// xc and yc are the center of the widget's rect.
	int xc = screenWidth * 0.5;
	int yc = screenHeight * 0.5;

	qDebug() << "[ImageEditor::processImage] sx: " << sx;

	QTransform trans;
	trans.translate(xc,yc);
	trans.translate(-sx,translationY);
	//trans.scale(scale, scale);
	trans.rotate(rotation);
	trans.translate(-xc,-yc);

	original = original.transformed(trans);

	// create a painter so we can draw on the image
	QPainter painter(&created);
	QTransform ptrans;
	ptrans.translate(-sx,translationY);
	painter.setTransform(ptrans);
	if(rotation != 0)
		painter.drawImage(0,0,original,sx,sx); // works with rotation but no translations
	else
		painter.drawImage(0,0,original,0,0);

	// Draw the center cross of the Painter
	painter.setPen(Qt::red);
	painter.drawLine(xc+sx, -translationY, xc+sx, screenHeight-translationY);
	painter.drawLine(sx, yc-translationY, screenWidth+sx, yc-translationY);

	// save the modified/painted image to the device
	QString imageName = decideImageName();
	created.save(workingDir + "/shared/photos/wappy/wappy-" + imageName+".jpg","JPG");

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
