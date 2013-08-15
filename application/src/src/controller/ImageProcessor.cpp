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

#include "ImageProcessor.h"
#include <QtGui/QImageReader>
#include <QtGui/QImage>
#include <QDebug>

ImageProcessor::ImageProcessor(const QString imagePath, QObject *parent)
	: QObject(parent)
	, m_imagePath(imagePath)
{
}

ImageProcessor::~ImageProcessor()
{
	this->deleteLater();
}

bb::ImageData ImageProcessor::start()
{
	//qDebug() << "[ImageProcessor::start] m_imagePath: " << m_imagePath;

	// XXX: Fix this when app quits -> ERROR: Context: Object name=" "ImageData" " [objectId= xyz ] not unrealized
	bb::ImageData imageData;
	QImage image, swappedImage;

	if(m_imagePath.length() > 0){
		QImageReader reader(m_imagePath);
		image = reader.read();

		//qDebug() << "[ImageProcessor::start] image.width: " << image.width() << ", bytes: " << image.numBytes();

		// Scale all images really fast to the same square size
		if(image.width() > 0){
			swappedImage = image.scaled(512, 512, Qt::KeepAspectRatioByExpanding).scaled(256, 256, Qt::KeepAspectRatioByExpanding).rgbSwapped();
		}
		else {
			qWarning() << "[ImageProcessor::start] could not load image file path!!! errorString: " << reader.errorString();
			return imageData;
		}

		// Images can have different aspect ratios so we get only a square part of it so that the IIB (grid) looks even
		swappedImage = swappedImage.copy(QRect(0,0,256,256));

		imageData = bb::ImageData::fromPixels(swappedImage.bits(), bb::PixelFormat::RGBX, swappedImage.width(), swappedImage.height(), swappedImage.bytesPerLine());
	}
	return imageData;
}
