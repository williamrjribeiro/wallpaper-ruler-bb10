// Default empty project template
#ifndef WallPaperRuler_HPP_
#define WallPaperRuler_HPP_

#include <QObject>

namespace bb { namespace cascades { class Application; }}

/*!
 * @brief Application pane object
 *
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class WallPaperRuler : public QObject
{
    Q_OBJECT
public:
    WallPaperRuler(bb::cascades::Application *app);
    virtual ~WallPaperRuler() {}
};


#endif /* WallPaperRuler_HPP_ */
