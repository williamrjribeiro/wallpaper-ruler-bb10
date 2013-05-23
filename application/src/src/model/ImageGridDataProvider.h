#ifndef IMAGEGRIDDATAPROVIDER_H
#define IMAGEGRIDDATAPROVIDER_H

#include <QObject>
#include <QDir>
#include <QStack>
#include <bb/cascades/ArrayDataModel>

class ImageGridDataProvider: public QObject {

	Q_OBJECT
	Q_PROPERTY(bb::cascades::DataModel* dataModel READ dataModel CONSTANT)


public:
	ImageGridDataProvider();
	virtual ~ImageGridDataProvider(){};

	QStack<QString> *filesStack;

	bb::cascades::DataModel *dataModel() const;

	Q_INVOKABLE void loadDataModel();

	void addPicturesToList(QDir dir);
private:
	bb::cascades::ArrayDataModel* m_dataModel;
};
#endif /* IMAGEGRIDDATAPROVIDER_H */
