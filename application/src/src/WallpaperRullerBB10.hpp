// Default empty project template
#ifndef WallpaperRullerBB10_HPP_
#define WallpaperRullerBB10_HPP_

#include <QObject>

namespace bb { namespace cascades { class Application; }}

/*!
 * @brief Application pane object
 *
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class WallpaperRullerBB10 : public QObject
{
    Q_OBJECT
public:
    WallpaperRullerBB10(bb::cascades::Application *app);
    virtual ~WallpaperRullerBB10() {}
};


#endif /* WallpaperRullerBB10_HPP_ */
