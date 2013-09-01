#include "ImageGridDataProvider.h"
#include "ImageLoader.h"
#include <QStringListIterator>
#include <QDir>
#include <QDebug>

using namespace bb::cascades;

const int ImageGridDataProvider::MAX_ITENS = 18;

ImageGridDataProvider::ImageGridDataProvider(QObject *parent)
	: QObject(parent)
	, m_dataModel(new QListDataModel<QObject*>())
	, m_loadedItems(0)
{
	m_dataModel->setParent(this);
	m_dataModel->clear();
	this->m_imageFilePaths.append( this->getAllImagePaths(QDir::currentPath()+"/shared") );
}

ImageGridDataProvider::~ImageGridDataProvider()
{
	qDebug() << "[ImageGridDataProvider::~ImageGridDataProvider]";

	m_dataModel->disconnect();
	m_dataModel->clear();
	m_dataModel->deleteLater();

	m_imageFilePaths.clear();
}

QStringList ImageGridDataProvider::getAllImagePaths(QString workingDir, bool allChildFolders)
{
	qDebug() << "[ImageGridDataProvider::getAllImagePaths] workingDir: " << workingDir<<", allChildFolders: "<<allChildFolders;

	QStringList found;

	// All the folders that we look for images
	QStringList listDirectories;
	if(!allChildFolders){
		listDirectories << "/downloads/"
						<< "/camera/"
						<< "/documents/"
						<< "/documents/"
						<< "/photos/";
	}
	else {
		listDirectories << "/";
	}

	// Only look for this type of images
	QStringList filters;
	filters << "*.jpeg" << "*.png" << "*.jpg" << "*.bmp";

	for (int i = 0; i < listDirectories.size(); ++i) {
		QDir dir(workingDir + listDirectories.at(i));
		dir.setFilter(QDir::Files | QDir::Dirs | QDir::NoDot | QDir::NoDotDot);
		dir.setNameFilters(filters);

		QDirIterator it(dir, QDirIterator::Subdirectories);

		while(it.hasNext()) {
			found.append(it.next());
		}
	}

	qDebug() << "[ImageGridDataProvider::getAllImagePaths] found.size: " << found.size();
	return found;
}

QUrl ImageGridDataProvider::getImageURL(int indexPath)
{
	qDebug() << "[ImageGridDataProvider::getImageURL] indexPath: " << indexPath;
	return QUrl("file://" + this->m_imageFilePaths[indexPath]);
}

void ImageGridDataProvider::addImage(QString filePath)
{
	qDebug() << "[ImageGridDataProvider::addImage] filePath: " << filePath;
	this->m_imageFilePaths.append(filePath);
}

int ImageGridDataProvider::clearOldThumbs() {
	int count = 0;
	QStringList thumbs = this->getAllImagePaths(QDir::homePath(), true);
	QString picPath, thumbPath;

	for (int i = 0; i < thumbs.size(); ++i) {
		thumbPath = thumbs.at(i);
		picPath = QDir::currentPath() + "/shared/" + thumbPath.section("/",5,-1,QString::SectionSkipEmpty);

		//qDebug() << "[ImageGridDataProvider::clearOldThumbs] i:"<< i <<", thumbPath: " << thumbPath <<", picPath: " << picPath;

		// The thumnails are always saved .jpg but the original file can still be png, jpeg or bmp so we must check all!
		if( !QFile(picPath).exists()
			&& !QFile(picPath.replace(".jpg",".png")).exists()
			&& !QFile(picPath.replace(".jpg",".bmp")).exists()
			&& !QFile(picPath.replace(".jpg",".jpeg")).exists() ){
				if( QFile(thumbPath).remove() ){
					count++;
					//qDebug() << "[ImageGridDataProvider::clearOldThumbs] deleted i:"<< i <<", thumbPath: " << thumbPath;

					// try to remove directory. it succeeds if it's empty
					if(QDir(thumbPath).rmdir( QFileInfo(thumbPath).path() ) ){
						qDebug() << "[ImageGridDataProvider::clearOldThumbs] empty folder removed: " << thumbPath;
					}
				}
				//else qDebug() << "[ImageGridDataProvider::clearOldThumbs] could not delete thumbs["<< i <<"]: " << thumbPath;
		}
	}

	qDebug() << "[ImageGridDataProvider::clearOldThumbs] count: " << count;
	return count;
}

bb::cascades::DataModel* ImageGridDataProvider::dataModel() const
{
	return m_dataModel;
}

void ImageGridDataProvider::loadMoreImages()
{
	int count = 0;
	int s = this->m_imageFilePaths.size();

	qDebug() << "[ImageGridDataProvider::loadMoreImages] m_loadedItems: " << m_loadedItems << ", s: " << s;

	if(m_loadedItems < s){

		while( count < ImageGridDataProvider::MAX_ITENS && s > (count + m_loadedItems) ){

			// don't forget to set the Parent Object or else is memory leak!
			ImageLoader *loader = new ImageLoader( m_imageFilePaths.at(m_loadedItems + count), this );

			bool ok = connect(loader,
							SIGNAL(imageChanged()), this,
							SLOT(onImageChanged()));
			Q_UNUSED(ok);
			Q_ASSERT_X(ok,"[ImageGridDataProvider::loadMoreImages]", "connect imageChanged failed");

			m_dataModel->append( loader );
			loader->load();
			++count;
		}
	}
}

void ImageGridDataProvider::onImageChanged()
{
	m_loadedItems++;
	//qDebug() << "[ImageGridDataProvider::onImageChanged] m_loadedItems: " << m_loadedItems;
	emit loadCountChange(m_loadedItems);
}

int ImageGridDataProvider::getLoadCount()
{
	return m_loadedItems;
}

int ImageGridDataProvider::getImagesCount()
{
	return m_imageFilePaths.size();
}
