/* Copyright (c) 2012 Research In Motion Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "ImageLoader.h"

#include <QUrl>
#include <QDebug>

/**
 *  This class implements a image loader which will initialize a network request in asynchronous manner.
 *  After receiving response from the network, it creates a QImage object in its own thread.
 *  Then it signals the interested parties about the result.
 */

/**
 *  Constructor
 */
ImageLoader::ImageLoader(const QString &imageUrl, QObject* parent)
	: QObject(parent)
	, m_image(NULL)
	, m_imageProcessor(NULL)
	, m_loading(false)
	, m_imageUrl(imageUrl)
	, m_watcher(this)
{
	//qDebug() << "[ImageLoader::ImageLoader] m_imageUrl: " << m_imageUrl;
}

/**
 * Destructor
 */
ImageLoader::~ImageLoader() {
	m_watcher.disconnect();
	m_watcher.deleteLater();
	if(m_imageProcessor != NULL){
		delete m_imageProcessor;
	}
}

/**
 * ImageLoader::load()
 *
 * Instruct the QNetworkAccessManager to initialize a network request in asynchronous manner.
 *
 * Also, setup the signal handler to receive the event indicating the network response.
 */
void ImageLoader::load()
{
	//qDebug() << "[ImageLoader::load] m_imageUrl: " << m_imageUrl;

	m_loading = true;
	emit loadingChanged();

	// Setup the image processing thread
	this->m_imageProcessor = new ImageProcessor(m_imageUrl,this);

	QFuture<bb::ImageData> future = QtConcurrent::run(m_imageProcessor, &ImageProcessor::start);

	// If any Q_ASSERT statement(s) indicate that the slot failed to connect to
	// the signal, make sure you know exactly why this has happened. This is not
	// normal, and will cause your app to stop working!
	bool connectResult;

	// Since the variable is not used in the app, this is added to avoid a compiler warning.
	Q_UNUSED(connectResult);

	// Invoke our onProcessingFinished slot after the processing has finished.
	// http://qt-project.org/doc/qt-4.8/qt.html#ConnectionType-enum
	connectResult = connect(&m_watcher, SIGNAL(finished()), this, SLOT(onImageProcessingFinished()), Qt::QueuedConnection);

	// This affects only Debug builds.
	Q_ASSERT(connectResult);

	// starts watching the given future
	m_watcher.setFuture(future);
}

/**
 * ImageLoader::onImageProcessingFinished()
 *
 * Handler for the signal indicating the result of the image processing.
 */
void ImageLoader::onImageProcessingFinished()
{
	//qDebug() << "[ImageLoader::onImageProcessingFinished] m_imageUrl: " << m_imageUrl;

	m_image = bb::cascades::Image(m_watcher.future().result());

	emit imageChanged();

	m_loading = false;
	emit loadingChanged();
}

QVariant ImageLoader::image() const
{
	return QVariant::fromValue(m_image);
}

bool ImageLoader::loading() const
{
	return m_loading;
}
