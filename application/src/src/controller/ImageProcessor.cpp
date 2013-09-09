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
#include <QDir>
#include <QDebug>

const QSize ImageProcessor::THUMB_SIZE = QSize(256,256);

ImageProcessor::ImageProcessor(const QString imagePath, QObject *parent)
	: QObject(parent)
	, m_imagePath(imagePath)
{
}

ImageProcessor::~ImageProcessor()
{
	//qDebug() << "[ImageProcessor::~ImageProcessor]";
}

bb::ImageData ImageProcessor::start()
{
	//qDebug() << "[ImageProcessor::start] m_imagePath: " << m_imagePath;

	bb::ImageData imageData;
	QImage image, swappedImage;

	QImageReader reader (m_imagePath);
	QSize scaledSize(ImageProcessor::THUMB_SIZE), originalSize = reader.size();

	if(originalSize != ImageProcessor::THUMB_SIZE && originalSize.isValid()){
		// now scale it filling the original rectangle by keeping aspect ratio
		scaledSize.scale(originalSize, Qt::KeepAspectRatio);

		// set the adjusted clipping rectangle in the middle of the original image
		QRect clipRect(0, 0, scaledSize.width(), scaledSize.height());
		QPoint originalCenterPoint(originalSize.width() / 2, originalSize.height() / 2);
		clipRect.moveCenter(originalCenterPoint);

		reader.setClipRect(clipRect);

		// set requested target size of a thumbnail
		// as clipping rectangle is of same aspect ration as requestedSize no distortion should happen
		reader.setScaledSize(ImageProcessor::THUMB_SIZE);

		if(reader.read(&image) == false){
			qWarning() << "[ImageProcessor::start] could not load image file! errorString: " << reader.errorString();
						return imageData;
		}
	}

	// get the parent folder of the current image
	//      0        1    2       3                                                     4      5      6     7
	// E.g: /accounts/1000/appdata/com.willthrill.bb10.Wappy.testDev__bb10_Wappy92abc424/shared/photos/wappy/image.jpg
	QString filePath = reader.fileName();
	int count = filePath.count("/");
	QString parentFolderName = "/" + filePath.section("/", 5, count - 2, QString::SectionSkipEmpty); // discard file name + 1
	QString fileName = "/" + filePath.section("/", -1);

	//qDebug() << "[ImageProcessor::start] parentFolderName: "<<parentFolderName<<", filePath: "<<filePath << ", count: " << count;

	// create the parent folder on the data directory if it doesn't exist.
	QDir parentFolder( QDir::homePath() + parentFolderName);
	if( !parentFolder.exists()){
		parentFolder.mkpath(".");
	}

	// save the thumbnail
	QString p = QDir::homePath() + parentFolderName + fileName;

	//qDebug() << "[ImageProcessor::start] Saving thumbnail image. File path: " << p;

	bool ok = image.save(p,"jpg",50);

	if(!ok){
		qWarning() << "[ImageProcessor::start] Could not save thumbnail image!";
	}

	// Swap the image colors due to RGB bit representation
	swappedImage = image.rgbSwapped();

	// Create the Cascades ImageData with the swapped image
	imageData = bb::ImageData::fromPixels(swappedImage.bits(), bb::PixelFormat::RGBX, swappedImage.width(), swappedImage.height(), swappedImage.bytesPerLine());
	return imageData;
}
