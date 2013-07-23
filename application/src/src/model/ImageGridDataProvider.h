#ifndef IMAGEGRIDDATAPROVIDER_H
#define IMAGEGRIDDATAPROVIDER_H

#include <QObject>
#include <QStringList>
#include <QUrl>
#include <bb/cascades/QListDataModel>

class ImageGridDataProvider: public QObject {

	Q_OBJECT
	Q_PROPERTY(bb::cascades::DataModel* dataModel READ dataModel CONSTANT)

public:

	// The maximum number of images that are added to the model at a single time
	static const int MAX_ITENS;

	ImageGridDataProvider(QObject *parent = 0);
	virtual ~ImageGridDataProvider();

	// A list of all image files found on the device
	QStringList m_imageFiles;

	// A list of ImageLoader's that will load the image and start a new thread to create the thumbnail
	bb::cascades::DataModel *dataModel() const;

	// Reads the folders dowloads, camera, photos, documents and get all jpg, jpeg and png files.
	Q_INVOKABLE void getAllImagePaths();

	// Start loading MAX_ITENS images
	Q_INVOKABLE void loadMoreImages();

	// Retrieves a file:// url from the specified indexPath. It has to be inside the bounds of the fileStack
	Q_INVOKABLE QUrl getImageURL(int indexPath);

	// Adds a new image to the fileStack
	Q_INVOKABLE void addImage(QString);

private:
	bb::cascades::QListDataModel<QObject*>* m_dataModel;

	int m_loadedItems;
};
#endif /* IMAGEGRIDDATAPROVIDER_H */
