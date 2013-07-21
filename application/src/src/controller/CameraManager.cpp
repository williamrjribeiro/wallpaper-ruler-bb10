/*
 * CameraManager.cpp
 *
 *  Created on: May 7, 2013
 *      Author: WilliamRafael
 */

#include "CameraManager.hpp"

#include <QDebug>
#include <bb/system/InvokeManager>
#include <bb/system/InvokeRequest>
#include <bb/cascades/multimedia/CameraSettings>
#include <bb/cascades/multimedia/CameraFocusMode>
#include <bb/cascades/multimedia/CameraShootingMode>

using namespace bb::system;
using namespace bb::cascades;
using namespace bb::cascades::multimedia;

// Macro for getting the difference in x and y direction
#define DELTA(x, y) (x>y?(x-y):(y-x))

CameraManager::CameraManager(ImageGridDataProvider *model, QObject *parent)
	: QObject(parent)
	, m_model(model)
	, m_capturedImage("")
	, m_zoomLevel(0)
	, m_maxZoomLevel(0)
{
	qDebug() << "[CameraManager::CameraManager]";
}

bool CameraManager::invokeCamera()
{
	qDebug() << "[CameraManager::invokeCamera]";

	InvokeManager *invokeManager = new InvokeManager(this);
	InvokeRequest request;
	request.setTarget("sys.camera.card");
	request.setAction("bb.action.CAPTURE");
	request.setMimeType("image/jpg");
	request.setData("photo");
	bool connectResult = false;
	Q_UNUSED(connectResult);
	connectResult = connect(invokeManager, SIGNAL(childCardDone(const bb::system::CardDoneMessage&)),
				this, SLOT(onCameraInvoke(const bb::system::CardDoneMessage&)));

	Q_ASSERT(connectResult);

	if(connectResult){
		// we can safely ignore the Reply from this invoke call. Everything is handled on the SLOT onCameraInvoke
		invokeManager->invoke(request);
	}
	else{
		qDebug() << "[CameraManager::invokeCamera] ERROR! Failed to invoke the Camera Card.";
	}
	return connectResult;
}

void CameraManager::onCameraInvoke(const CardDoneMessage &message)
{
	qDebug() << "[CameraManager::onCameraInvoke] message.data.isEmpty: " << message.data().isEmpty()
			<< ", message.reason: " << message.reason() << ", message.data: " << message.data();
	if(!message.data().isEmpty()){
		// add the path to the file of the captured image to the Application Model so it shows up on the IIC.
		//this->m_model->loadMoreImages();

		// update the m_capturedImage property with the value from the Data.
		this->setCapturedImage(message.data());
	}
}

void CameraManager::selectAspectRatio(Camera *camera, const float aspect)
{
	qDebug() << "[CameraManager::selectAspectRatio] camera: "  << camera << ", aspect: " << aspect;

	CameraSettings camsettings;
	camera->getSettings(&camsettings);

	// Get a list of supported resolutions.
	QVariantList reslist = camera->supportedCaptureResolutions(CameraMode::Photo);

	// Find the closest match to the aspect parameter
	for (int i = 0; i < reslist.count(); i++) {
		QSize res = reslist[i].toSize();
		qDebug() << "[CameraManager::selectAspectRatio] supported resolution: " << res.width() << "x" << res.height();

		// Check for w:h or h:w within 5px margin of error...
		if ((DELTA(res.width() * aspect, res.height()) < 5)
				|| (DELTA(res.width(), res.height() * aspect) < 5)) {
			qDebug() << "[CameraManager::selectAspectRatio] picking resolution: " << res.width() << "x" << res.height();
			camsettings.setCaptureResolution(res);
			break;
		}
	}

	camsettings.setFocusMode(CameraFocusMode::ContinuousAuto);
	camsettings.setShootingMode(CameraShootingMode::Stabilization);

	// Save pictures taken to a custom folder on the Camera Roll
	camsettings.setCameraRollPath("/accounts/1000/shared/camera/WPR/");

	// Update the camera setting
	camera->applySettings(&camsettings);

	// update the Max Zoom Level of the current Camera
	this->m_maxZoomLevel = camera->maxZoomLevel();
}

void CameraManager::setCameraZoomByPinchRatio(Camera *camera, const float pinchRatio)
{
	//qDebug() << "[CameraManager::setCameraZoomByPinchRatio] camera: "  << camera << ", pinchRatio: " << pinchRatio;

	// determine if the user is pinching in our out
	if(pinchRatio - 1 >= 0){
		//this->setZoomLevel( this->m_zoomLevel + 1);
		this->m_zoomLevel++;
	}
	else {
		//this->setZoomLevel( this->m_zoomLevel > 0 ? this->m_zoomLevel - 1 : 0);
		this->m_zoomLevel--;
	}

	CameraSettings camsettings;
	camera->getSettings(&camsettings);

	camsettings.setZoomLevel(this->m_zoomLevel);

	// Update the camera setting
	camera->applySettings(&camsettings);
}

QString CameraManager::capturedImage() const
{
	return this->m_capturedImage;
}

void CameraManager::setCapturedImage(const QString imagePath)
{
	//qDebug() << "[CameraManager::setCapturedImage] imagePath: "  << imagePath;

	// Add the file:// protocol if the imagePath doesn't have it yet. Or else the image won't be loaded.
	//this->m_capturedImage = !imagePath.startsWith("file://") ? "file://" + imagePath : imagePath;
	this->m_capturedImage = imagePath;

	// emit a signal that the image has been captured
	emit imageCaptured(this->m_capturedImage);
}

bool CameraManager::saveCapturedImage(const bool mirrored)
{
	qDebug() << "[CameraManager::saveCapturedImage] m_capturedImage: "  << this->m_capturedImage << ", mirrored: " << mirrored;

	// TODO

	return false;
}

unsigned int CameraManager::zoomLevel() const
{
	return this->m_zoomLevel;
}

void CameraManager::setZoomLevel(const unsigned int value)
{
	//qDebug() << "[CameraManager::setZoomLevel] value: "  << value;

	// only deal with different values
	if(this->m_zoomLevel != value){

		// never exceed the maximum zoom level
		if( value > this->m_maxZoomLevel){
			this->m_zoomLevel = this->m_maxZoomLevel;
		}
		else {
			this->m_zoomLevel = value;
		}

		// Idealy we should change the Camera Settings using this signal
		// but it's not yet possible to change the Zoom Level via QML.
		// Must use setCameraZoomByPinchRatio() instead.
		emit zoomLevelChanged(this->m_zoomLevel);
	}
}
