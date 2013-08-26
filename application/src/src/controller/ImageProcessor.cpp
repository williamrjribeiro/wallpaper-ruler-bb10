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

	if(m_imagePath.length() > 0){
		QImageReader reader(m_imagePath);
		image = reader.read();

		//qDebug() << "[ImageProcessor::start] image.width: " << image.width() << ", bytes: " << image.numBytes();

		// Scale all images really fast to the same square size
		if(image.width() > 0){
			image = image.scaled(512, 512, Qt::KeepAspectRatioByExpanding).scaled(256, 256, Qt::KeepAspectRatioByExpanding);
		}
		else {
			qWarning() << "[ImageProcessor::start] could not load image file! errorString: " << reader.errorString();
			return imageData;
		}

		// Images can have different aspect ratios so we get only a square part of it so that the IIB (grid) looks even
		image = image.copy(QRect(0,0,256,256));

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
	}
	return imageData;
}
