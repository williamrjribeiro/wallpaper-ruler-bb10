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

#ifndef IMAGELOADER_HPP
#define IMAGELOADER_HPP

#include <bb/cascades/ResourceState>
#include <bb/cascades/Image>
#include <bb/cascades/ImageTracker>
#include <bb/ImageData>

#include "ImageProcessor.h"

/*
 * This class retrieves an image from the device, then converts the binary
 * data into a bb::cascades::Image and makes it available through a property.
 */
class ImageLoader : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariant image READ image NOTIFY imageChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)

public:
    /*
     * Creates a new image loader.
     *
     * @param imageUrl The url to load the image from.
     */
    ImageLoader(const QString &imageUrl, QObject* parent = 0);

    ~ImageLoader();

    void load();

Q_SIGNALS:
    void imageChanged();
    void labelChanged();
    void loadingChanged();

private Q_SLOTS:
    /*
     * Response handler for the image process operation.
     */
    void onImageProcessingFinished();

    void onImageTrackerStateChanged(bb::cascades::ResourceState::Type);

private:
    // The accessor methods of the properties
    QVariant image() const;
    bool loading() const;

    // The property values
    bb::cascades::Image m_image;
    bb::cascades::ImageTracker *m_imageTracker;
    ImageProcessor *m_imageProcessor;
    bool m_loading;

    // The URL of the image that should be loaded
    QString m_imageUrl;

    // The thread status watcher
    QFutureWatcher<bb::ImageData> m_watcher;
};

#endif
