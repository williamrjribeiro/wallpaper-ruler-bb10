/*
 * CameraManager.hpp
 *
 *  Created on: May 7, 2013
 *      Author: WilliamRafael
 */

#ifndef CAMERAMANAGER_HPP_
#define CAMERAMANAGER_HPP_

#include <QObject>
#include <bb/system/CardDoneMessage>
#include <bb/cascades/multimedia/Camera>
#include "model/ImageGridDataProvider.h"

class CameraManager: public QObject {

	Q_OBJECT

	Q_PROPERTY(QString capturedImage READ capturedImage WRITE setCapturedImage NOTIFY imageCaptured FINAL)

public:
	CameraManager(ImageGridDataProvider *model, QObject *parent = 0);
	virtual ~CameraManager(){};

	Q_INVOKABLE bool invokeCamera();

	/**
	 *  Function that lets you set up the aspect ratio of the camera, there
	 *  are limitations to the allowed values, the function will look for the
	 *  closest match.
	 *
	 *  @param camera the file path to the bombed image
	 *  @param aspect The ratio of w/h that should be used for the viewfinder
	 */
	Q_INVOKABLE void selectAspectRatio(bb::cascades::multimedia::Camera *camera, const float aspect);

	/**
	 * Function that saves the capture image to the Camera Roll default folder.
	 * @param mirrored true if the image is mirrored. false otherwise. The file is un-mirrored before saving if true.
	 * @return false if it was not possible to save the file. True otherwise.
	 */
	Q_INVOKABLE bool saveCapturedImage(const bool mirrored);

	// Getter for the Q_PROPERTY capturedImage
	QString capturedImage() const;

	// Setter for the Q_PROPERTy capturedImage
	void setCapturedImage(const QString imagePath);

signals:
	// Signal for the Q_PROPERTy capturedImage
	void imageCaptured(const QString imagePath);

private Q_SLOTS:
	void onCameraInvoke(const bb::system::CardDoneMessage &message);

private:
	ImageGridDataProvider *m_model;
	QString m_capturedImage;
};

#endif /* CAMERAMANAGER_HPP_ */
