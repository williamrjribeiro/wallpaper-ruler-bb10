#include "ImageGridDataProvider.h"
#include "ImageLoader.h"
#include <QStringListIterator>
#include <QDir>
#include <QDebug>

using namespace bb::cascades;

const int ImageGridDataProvider::MAX_ITENS = 15;

ImageGridDataProvider::ImageGridDataProvider(QStringList filters, QObject *parent)
	: QObject(parent)
	, m_dataModel(new QListDataModel<ImageLoader*>())
	, m_loadedItems(0)
	, m_loadingCount(0)
	, m_filters(filters)
{
	m_dataModel->setParent(this);
	m_dataModel->clear();
	// look for images on the device and store the file paths for loading later
	this->m_imageFilePaths.append( this->getAllImagePaths(QDir::currentPath()+"/shared", m_filters) );
}

ImageGridDataProvider::~ImageGridDataProvider()
{
	qDebug() << "[ImageGridDataProvider::~ImageGridDataProvider]";

	m_dataModel->disconnect();
	m_dataModel->clear();
	m_dataModel->deleteLater();

	m_imageFilePaths.clear();
}

QStringList ImageGridDataProvider::getAllImagePaths(QString workingDir, QStringList filters, bool allChildFolders)
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
	//QStringList filters;
	//filters << "*.jpeg" << "*.png" << "*.jpg" << "*.bmp";

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

int ImageGridDataProvider::clearOldThumbs() {
	int count = 0;
	// The thumbnail images are stored on the app's private folder
	QStringList thumbs = this->getAllImagePaths(QDir::homePath(), m_filters, true);
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

void ImageGridDataProvider::loadMoreImages()
{
	int count = 0;
	int s = this->m_imageFilePaths.size();

	qDebug() << "[ImageGridDataProvider::loadMoreImages] m_loadedItems: " << m_loadedItems << ", s: " << s << ", m_loadingCount: " << m_loadingCount;

	// Make sure the model never loads more images than it should at the same time or more than it should
	if(m_loadingCount == 0 && m_loadedItems < s){

		ImageLoader *loader = NULL;
		while( count < ImageGridDataProvider::MAX_ITENS && s > (count + m_loadedItems) ){

			// don't forget to set the Parent Object or else is memory leak!
			loader = new ImageLoader( m_imageFilePaths.at(m_loadedItems + count), this);

			bool ok = connect(loader,
							SIGNAL(imageChanged()), this,
							SLOT(onImageChanged()));
			Q_UNUSED(ok);
			Q_ASSERT_X(ok,"[ImageGridDataProvider::loadMoreImages]", "connect imageChanged failed");

			m_dataModel->append( loader );
			loader->load();

			// Don't start loading images while ImageLoader instances are created on this while loop or else we have a race condition!
			// m_loadedItems is incremented on onImageChanged and it's possible that an image is finished loading before the while is done.

			++count;
			++m_loadingCount;
			Q_ASSERT_X(m_loadingCount <= ImageGridDataProvider::MAX_ITENS,"[ImageGridDataProvider::loadMoreImages]", "loading count max exceed!");
		}

		// Start loading the images only after the loop is done! This a very simple way of preventing the race condition.
		/*for(int i = 0; i < count; i++){
			loader = m_dataModel->value(m_loadedItems + i);
			loader->load();
		}*/
		loader = NULL;
	}
	else{
		qDebug() << "[ImageGridDataProvider::loadMoreImages] maximum loading reached! Must wait until all images finish loading or must add new images to load.";
	}
}

void ImageGridDataProvider::onImageChanged()
{
	m_loadedItems++;
	m_loadingCount--;
	qDebug() << "[ImageGridDataProvider::onImageChanged] m_loadedItems: " << m_loadedItems << ", m_loadingCount: " << m_loadingCount;
	emit loadCountChange(m_loadedItems);
	// Automatically load more images
	if(m_loadingCount == 0){
		loadMoreImages();
	}
}

int ImageGridDataProvider::getLoadCount()
{
	return m_loadedItems;
}

int ImageGridDataProvider::getImagesCount()
{
	return m_imageFilePaths.size();
}

bb::cascades::DataModel* ImageGridDataProvider::dataModel() const
{
	return m_dataModel;
}

QUrl ImageGridDataProvider::getImageURL(int indexPath)
{
	qDebug() << "[ImageGridDataProvider::getImageURL] indexPath: " << indexPath;
	return QUrl("file://" + this->m_imageFilePaths[indexPath]);
}

void ImageGridDataProvider::addImage(QString filePath)
{
	qDebug() << "[ImageGridDataProvider::addImage] filePath: " << filePath;
	m_imageFilePaths.append(filePath);
	loadMoreImages();
}
