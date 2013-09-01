#ifndef IMAGEGRIDDATAPROVIDER_H
#define IMAGEGRIDDATAPROVIDER_H

#include <QObject>
#include <QStringList>
#include <QUrl>
#include <bb/cascades/QListDataModel>

class ImageGridDataProvider: public QObject {

	Q_OBJECT
	Q_PROPERTY(bb::cascades::DataModel* dataModel READ dataModel CONSTANT FINAL)
	Q_PROPERTY(int loadCount READ getLoadCount NOTIFY loadCountChange FINAL)
	Q_PROPERTY(int imagesCount READ getImagesCount FINAL)

public:

	// The maximum number of images that are added to the model at a single time
	static const int MAX_ITENS;

	ImageGridDataProvider(QObject *parent = 0);
	virtual ~ImageGridDataProvider();

	// A list of ImageLoader's that will load the image and start a new thread to create the thumbnail
	bb::cascades::DataModel *dataModel() const;

	/**
	 * Reads the folders dowloads, camera, photos, documents and get all jpg, jpeg, bmp and png files.
	 * @param QString - the root path to search the images.
	 * @param bool - if true it will search all sub-directories of root dir else, it looks only for the sub-folders downloads, camera, photos & documents.
	 * @return the list with the path for all found image files.
	 */
	Q_INVOKABLE QStringList getAllImagePaths(QString, bool = false);

	// Start loading MAX_ITENS images
	Q_INVOKABLE void loadMoreImages();

	// Retrieves a file:// url from the specified indexPath. It has to be inside the bounds of the fileStack
	Q_INVOKABLE QUrl getImageURL(int indexPath);

	// Adds a new image to the fileStack
	Q_INVOKABLE void addImage(QString);

	/**
	 * Delete generated thumbnails that don't exist anymore on the device
	 * @return the number of removed thumbs.
	 */
	Q_INVOKABLE int clearOldThumbs();

Q_SIGNALS:
	void loadCountChange(int);

private:
	// The number of successfully loaded images
	int getLoadCount();

	// The number of images found on the device
	int getImagesCount();

	bb::cascades::QListDataModel<QObject*>* m_dataModel;

	// A list of all image files found on the device
	QStringList m_imageFilePaths;

	int m_loadedItems;

private Q_SLOTS:
	void onImageChanged();
};
#endif /* IMAGEGRIDDATAPROVIDER_H */
