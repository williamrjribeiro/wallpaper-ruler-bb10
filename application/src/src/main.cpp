// Default empty project template
#include "MyApplication.hpp"

#include <bb/cascades/Application>

#include <QDebug>

#include <Qt/qdeclarativedebug.h>

#ifndef QT_USE_FAST_CONCATENATION
#define QT_USE_FAST_CONCATENATION
#endif

#ifndef QT_USE_FAST_OPERATOR_PLUS
#define QT_USE_FAST_OPERATOR_PLUS
#endif

Q_DECL_EXPORT int main(int argc, char **argv)
{
    // this is where the server is started etc
	bb::cascades::Application app(argc, argv);

    new MyApplication(&app);

    // we complete the transaction started in the app constructor and start the client event loop here
    return bb::cascades::Application::exec();
    // when loop is exited the Application deletes the scene which deletes all its children (per qt rules for children)
}
