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
#include <QDir>
#include <QFile>
#include <QDebug>

/**
 *  This class implements a image loader which will initialize a ImageProcessor in asynchronous manner which generates
 *  the image thumb. After receiving the image data, it creates a QImage object in its own thread.
 *  Then it signals the interested parties about the result.
 */
using namespace bb;
using namespace bb::cascades;

ImageLoader::ImageLoader(const QString &imageUrl, QObject* parent)
	: QObject(parent)
	, m_image(NULL)
	, m_imageTracker(NULL)
	, m_imageProcessor(NULL)
	, m_loading(false)
	, m_imageUrl(imageUrl)
	, m_watcher(NULL)
{
	//qDebug() << "[ImageLoader::ImageLoader] m_imageUrl: " << m_imageUrl;
}

ImageLoader::~ImageLoader()
{
	//qDebug() << "[ImageLoader::~ImageLoader] m_watcher.isRunning: "<<m_watcher.isRunning();

	if(m_watcher != NULL){
		if(m_watcher->isRunning()){
			m_watcher->cancel();
			m_watcher->waitForFinished();
		}
		m_watcher->disconnect();
		m_watcher->deleteLater();
		m_watcher = NULL;
	}

	if(m_imageProcessor != NULL){
		m_imageProcessor->disconnect();
		delete m_imageProcessor;
	}

	if(m_imageTracker != NULL){
		m_imageTracker->disconnect();
		delete m_imageTracker;
	}
}

/**
 * ImageLoader::load()
 *
 * Instruct the ImageProcessor to initialize a image load and thumbnail creation in asynchronous manner.
 */
void ImageLoader::load()
{
	qDebug() << "[ImageLoader::load] m_imageUrl: " << m_imageUrl;

	m_loading = true;
	emit loadingChanged();

	// Create the path to the pre-generated thumbnail image
	QString thumbPath = QDir::homePath() + "/" + m_imageUrl.section("/",-2,-1,QString::SectionSkipEmpty);

	// If any Q_ASSERT statement(s) indicate that the slot failed to connect to
	// the signal, make sure you know exactly why this has happened. This is not
	// normal, and will cause your app to stop working!
	bool ok = false;
	// Since the variable is not used in the app, this is added to avoid a compiler warning.
	Q_UNUSED(ok);

	//qDebug() << "[ImageLoader::load] thumbPath: " << thumbPath;

	// Check if the pre-generated a thumbnail already exists
	if( QFile(thumbPath).exists() ){

		qDebug() << "[ImageLoader::load] thumbnail image FOUND!";

		// Load the thumbnail image directly to bb:cascades:Image
		m_imageTracker = new ImageTracker(QUrl("file://" + thumbPath), this);

		ok = connect(m_imageTracker,
				SIGNAL(stateChanged(bb::cascades::ResourceState::Type)),
				this,
				SLOT(onImageTrackerStateChanged(bb::cascades::ResourceState::Type)));

		Q_ASSERT_X(ok,"[ImageLoader::load]","connect stateChanged failed");
	}
	else{

		qDebug() << "[ImageLoader::load] thumbnail image NOT FOUND!";

		// Setup the image processing thread
		this->m_imageProcessor = new ImageProcessor(m_imageUrl,this);

		QFuture<bb::ImageData> future = QtConcurrent::run(m_imageProcessor, &ImageProcessor::start);

		// create a new Future Watcher
		m_watcher = new QFutureWatcher<ImageData>(this);

		// Invoke our onProcessingFinished slot after the processing has finished.
		// http://qt-project.org/doc/qt-4.8/qt.html#ConnectionType-enum
		ok = connect(m_watcher, SIGNAL(finished()), this, SLOT(onImageProcessingFinished()), Qt::QueuedConnection);

		// This affects only Debug builds.
		Q_ASSERT_X(ok,"[ImageLoader::load]","connect finished failed");

		// start watching the given future
		m_watcher->setFuture(future);
	}
}

/**
 * ImageLoader::onImageProcessingFinished()
 *
 * Handler for the signal indicating the result of the image processing.
 */
void ImageLoader::onImageProcessingFinished()
{
	qDebug() << "[ImageLoader::onImageProcessingFinished] m_imageUrl: " << m_imageUrl;

	// If the Future Watcher exists (other thread), create the Cascades Image from the Cascades ImageData from it
	if( m_watcher != NULL && m_image.source().isEmpty()){
		m_image = Image(m_watcher->future().result());

		// Free the memory as soon as possible. Must use deleteLater() because the objects were created on another thread
		m_imageProcessor->disconnect();
		m_imageProcessor->deleteLater();
		m_imageProcessor = NULL;

		m_watcher->disconnect();
		m_watcher->deleteLater();
		m_watcher = NULL;
	}

	emit imageChanged();

	m_loading = false;
	emit loadingChanged();
}

void ImageLoader::onImageTrackerStateChanged(ResourceState::Type state)
{
    if(state == ResourceState::Loaded) {
    	qDebug() << "[ImageLoader::onImageTrackerStateChanged] state: " << state <<" imageSource: " << m_imageTracker->imageSource();

    	// get the Cascades Image from the Image Tracker
        m_image = m_imageTracker->image();

        // Free the memory as soon as possible
        m_imageTracker->deleteLater();
        m_imageTracker = NULL;

        // Dispatch all the signals (loadingChanged and imageChanged)
        onImageProcessingFinished();
    }
}

QVariant ImageLoader::image() const
{
	return QVariant::fromValue(m_image);
}

bool ImageLoader::loading() const
{
	return m_loading;
}
