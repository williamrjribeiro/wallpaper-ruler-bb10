#ifndef SCREENSIZE_HPP_
#define SCREENSIZE_HPP_

#include <QObject>
#include <bb/device/DisplayInfo>
#include <bb/cascades/DisplayDirection>

class ScreenSize : public QObject {
    Q_OBJECT
    Q_PROPERTY(int width READ width NOTIFY widthChanged FINAL);
    Q_PROPERTY(int height READ height NOTIFY heightChanged FINAL);
    Q_PROPERTY(QSize res READ res NOTIFY resChanged FINAL);
    Q_PROPERTY(bb::cascades::DisplayDirection::Type displayDirection READ displayDirection NOTIFY displayDirectionChanged FINAL);

public:
    ScreenSize(QObject* parent = NULL);
    ScreenSize(int displayId, QObject* parent = NULL);
    ~ScreenSize();

    int width() const { return mRes.width(); }
    int height() const { return mRes.height(); }
    QSize res() const { return mRes; }
    bb::cascades::DisplayDirection::Type displayDirection() const { return mDisplayDirection; }

Q_SIGNALS:
    void widthChanged(int width);
    void heightChanged(int height);
    void resChanged(QSize res);
    void displayDirectionChanged(bb::cascades::DisplayDirection::Type direction);

private Q_SLOTS:
    void onSizeChanged(QSize pixelSize);
    void onDisplayDirectionChanged(bb::cascades::DisplayDirection::Type direction);

private:
    void init();
    void update(QSize res, bb::cascades::DisplayDirection::Type direction);
    bb::cascades::DisplayDirection::Type mDisplayDirection;
    QSize mRes;
    QSize mDisplayRes;
    bb::device::DisplayInfo mDisplayInfo;
};

#endif /* SCREENSIZE_HPP_ */
