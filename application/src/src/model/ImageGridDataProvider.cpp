/*
 * ImageGridDataProvider.cpp
 *
 *  Created on: 8 feb. 2013
 *      Author: P623893
 */

#include "ImageGridDataProvider.h"

#include <QDebug>

ImageGridDataProvider::ImageGridDataProvider()
{
	filesStack = new QStack<QString>();
	m_dataModel = new bb::cascades::ArrayDataModel();
	this->loadDataModel();
}

void ImageGridDataProvider::loadDataModel()
{
	qDebug() << "[ImageGridDataProvider::loadDatamodel]";


	QList<QString> listDirectories;
	listDirectories.append("/shared/downloads/");
	listDirectories.append("/shared/camera/");
	listDirectories.append("/shared/documents/");
	listDirectories.append("/shared/photos/");

	QStringList filters;
	filters << "*.jpeg" << "*.png" << "*.jpg";

	QList<QString> listPictures;

	QString workingDir = QDir::currentPath();

	filesStack->clear();

	for (int i = 0; i < listDirectories.size(); ++i) {
		QDir dir(workingDir + listDirectories.at(i));
		dir.setFilter(QDir::Files | QDir::Dirs | QDir::NoDot | QDir::NoDotDot);
		dir.setNameFilters(filters);
		addPicturesToList(dir);
	}
	m_dataModel->clear();

	for (int i = 0; i < filesStack->size(); ++i) {
		//m_dataModel->append(QUrl("file:///accounts/1000/shared/camera/Test.jpg"));
		//m_dataModel->append(QUrl("file://" + filesStack->at(i)));
		m_dataModel->append(QUrl(filesStack->at(i)));
		//qDebug() << qPrintable(QString("%1").arg(filesStack->at(i)));
	}
}

void ImageGridDataProvider::addPicturesToList(QDir dir)
{
	QDirIterator it(dir, QDirIterator::Subdirectories);
	while(it.hasNext()) {
		filesStack->push("file://" + it.next());
	}
}

bb::cascades::DataModel* ImageGridDataProvider::dataModel() const {
	return m_dataModel;
}
