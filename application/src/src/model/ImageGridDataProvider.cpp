#include "ImageGridDataProvider.h"
#include "ImageLoader.h"
#include <QDebug>
#include <QStringListIterator>

using namespace bb::cascades;

const int ImageGridDataProvider::MAX_ITENS = 18;

ImageGridDataProvider::ImageGridDataProvider(QObject *parent)
	: QObject(parent)
	, m_dataModel(new QListDataModel<QObject*>())
	, m_loadedItems(0)
{
	m_dataModel->setParent(this);

	this->getAllImagePaths();
}

ImageGridDataProvider::~ImageGridDataProvider()
{
	m_dataModel->clear();
	m_dataModel->deleteLater();

	m_imageFiles.clear();
}

void ImageGridDataProvider::getAllImagePaths()
{
	//qDebug() << "[ImageGridDataProvider::getAllImagePaths]";

	// All the folders that we look for images
	QStringList listDirectories;
	listDirectories << "/shared/downloads/"
					<< "/shared/camera/"
					<< "/shared/documents/"
					<< "/shared/photos/";

	// Only look for this type of images
	QStringList filters;
	filters << "*.jpeg" << "*.png" << "*.jpg";

	QString workingDir = QDir::currentPath();

	m_imageFiles.clear();

	for (int i = 0; i < listDirectories.size(); ++i) {
		QDir dir(workingDir + listDirectories.at(i));
		dir.setFilter(QDir::Files | QDir::Dirs | QDir::NoDot | QDir::NoDotDot);
		dir.setNameFilters(filters);

		QDirIterator it(dir, QDirIterator::Subdirectories);

		while(it.hasNext()) {
			m_imageFiles.append(it.next());
		}
	}

	qDebug() << "[ImageGridDataProvider::getAllImagePaths] m_imageFiles.size: " << m_imageFiles.size();
}

QUrl ImageGridDataProvider::getImageURL(int indexPath)
{
	qDebug() << "[ImageGridDataProvider::getImageURL] indexPath: " << indexPath;
	return QUrl("file://" + this->m_imageFiles[indexPath]);
}

void ImageGridDataProvider::addImage(QString filePath)
{
	qDebug() << "[ImageGridDataProvider::addImage] filePath: " << filePath;
	this->m_imageFiles.append(filePath);
}

bb::cascades::DataModel* ImageGridDataProvider::dataModel() const
{
	return m_dataModel;
}

void ImageGridDataProvider::loadMoreImages()
{
	int count = 0;
	int s = this->m_imageFiles.size();

		if(m_loadedItems < s){

			while( count < ImageGridDataProvider::MAX_ITENS && s > (count + m_loadedItems) ){

				ImageLoader *loader = new ImageLoader( m_imageFiles.at(m_loadedItems + count), this );
				loader->load();
				m_dataModel->append( loader );
				++count;
			}

			m_loadedItems += count;
		}

	qDebug() << "[ImageGridDataProvider::loadMoreImages] m_loadedItems: " << m_loadedItems;
}
