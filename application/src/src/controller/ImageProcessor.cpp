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

	QImage image, swappedImage;
	bb::ImageData imageData;

	if(m_imagePath.length() > 0){
		QImageReader reader(m_imagePath);
		image = reader.read();

		//qDebug() << "[ImageProcessor::start] image.width: " << image.width() << ", bytes: " << image.numBytes();

		if(image.width() > 0){
			swappedImage = image.scaled(400, 400, Qt::KeepAspectRatioByExpanding).scaled(200, 200, Qt::KeepAspectRatioByExpanding, Qt::SmoothTransformation).rgbSwapped();
			//swappedImage = halfSized(image).rgbSwapped();
			//swappedImage = image.scaled(200, 200, Qt::KeepAspectRatio, Qt::SmoothTransformation).rgbSwapped();
			imageData = bb::ImageData::fromPixels(swappedImage.bits(), bb::PixelFormat::RGBX, swappedImage.width(), swappedImage.height(), swappedImage.bytesPerLine());
		}
		else {
			qWarning() << "[ImageProcessor::start] could not load image file path!!! errorString: " << reader.errorString();
			return imageData;
		}
	}
	return imageData;
}

// for the explanation of the trick, check out:
// http://www.virtualdub.org/blog/pivot/entry.php?id=116
// http://www.compuphase.com/graphic/scale3.htm
// http://qt.gitorious.org/qt-labs/graphics-dojo/blobs/master/halfscale/halfscale.cpp
// http://blog.qt.digia.com/blog/2009/01/20/50-scaling-of-argb32-image/
#define AVG(a,b)  ( ((((a)^(b)) & 0xfefefefeUL) >> 1) + ((a)&(b)) )

QImage ImageProcessor::halfSized(const QImage &source)
{
    QImage dest(source.size() * 0.5, QImage::Format_ARGB32_Premultiplied);

    const quint32 *src = reinterpret_cast<const quint32*>(source.bits());
    int sx = source.bytesPerLine() >> 2;
    int sx2 = sx << 1;

    quint32 *dst = reinterpret_cast<quint32*>(dest.bits());
    int dx = dest.bytesPerLine() >> 2;
    int ww = dest.width();
    int hh = dest.height();

    for (int y = hh; y; --y, dst += dx, src += sx2) {
        const quint32 *p1 = src;
        const quint32 *p2 = src + sx;
        quint32 *q = dst;
        for (int x = ww; x; --x, q++, p1 += 2, p2 += 2)
            * q = AVG(AVG(p1[0], p1[1]), AVG(p2[0], p2[1]));
    }

    return dest;
}
