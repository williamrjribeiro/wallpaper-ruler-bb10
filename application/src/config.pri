# Auto-generated by IDE. Any changes made by user will be lost!
BASEDIR =  $$quote($$_PRO_FILE_PWD_)

device {
    CONFIG(release, debug|release) {
        SOURCES +=  $$quote($$BASEDIR/src/MyApplication.cpp) \
                 $$quote($$BASEDIR/src/controller/AppLocalization.cpp) \
                 $$quote($$BASEDIR/src/controller/AppSettings.cpp) \
                 $$quote($$BASEDIR/src/controller/CameraManager.cpp) \
                 $$quote($$BASEDIR/src/controller/ImageEditor.cpp) \
                 $$quote($$BASEDIR/src/controller/ImageLoader.cpp) \
                 $$quote($$BASEDIR/src/controller/ImageProcessor.cpp) \
                 $$quote($$BASEDIR/src/controller/ScreenSize.cpp) \
                 $$quote($$BASEDIR/src/main.cpp) \
                 $$quote($$BASEDIR/src/model/ImageGridDataProvider.cpp)

        HEADERS +=  $$quote($$BASEDIR/src/MyApplication.hpp) \
                 $$quote($$BASEDIR/src/controller/AppLocalization.h) \
                 $$quote($$BASEDIR/src/controller/AppSettings.hpp) \
                 $$quote($$BASEDIR/src/controller/CameraManager.hpp) \
                 $$quote($$BASEDIR/src/controller/ImageEditor.h) \
                 $$quote($$BASEDIR/src/controller/ImageLoader.h) \
                 $$quote($$BASEDIR/src/controller/ImageProcessor.h) \
                 $$quote($$BASEDIR/src/controller/ScreenSize.hpp) \
                 $$quote($$BASEDIR/src/model/ImageGridDataProvider.h)
    }

    CONFIG(debug, debug|release) {
        SOURCES +=  $$quote($$BASEDIR/src/MyApplication.cpp) \
                 $$quote($$BASEDIR/src/controller/AppLocalization.cpp) \
                 $$quote($$BASEDIR/src/controller/AppSettings.cpp) \
                 $$quote($$BASEDIR/src/controller/CameraManager.cpp) \
                 $$quote($$BASEDIR/src/controller/ImageEditor.cpp) \
                 $$quote($$BASEDIR/src/controller/ImageLoader.cpp) \
                 $$quote($$BASEDIR/src/controller/ImageProcessor.cpp) \
                 $$quote($$BASEDIR/src/controller/ScreenSize.cpp) \
                 $$quote($$BASEDIR/src/main.cpp) \
                 $$quote($$BASEDIR/src/model/ImageGridDataProvider.cpp)

        HEADERS +=  $$quote($$BASEDIR/src/MyApplication.hpp) \
                 $$quote($$BASEDIR/src/controller/AppLocalization.h) \
                 $$quote($$BASEDIR/src/controller/AppSettings.hpp) \
                 $$quote($$BASEDIR/src/controller/CameraManager.hpp) \
                 $$quote($$BASEDIR/src/controller/ImageEditor.h) \
                 $$quote($$BASEDIR/src/controller/ImageLoader.h) \
                 $$quote($$BASEDIR/src/controller/ImageProcessor.h) \
                 $$quote($$BASEDIR/src/controller/ScreenSize.hpp) \
                 $$quote($$BASEDIR/src/model/ImageGridDataProvider.h)
    }
}

INCLUDEPATH +=  $$quote($$BASEDIR/src/controller) \
         $$quote($$BASEDIR/src/model) \
         $$quote($$BASEDIR/src)

CONFIG += precompile_header

PRECOMPILED_HEADER =  $$quote($$BASEDIR/precompiled.h)

lupdate_inclusion {
    SOURCES +=  $$quote($$BASEDIR/../src/*.c) \
             $$quote($$BASEDIR/../src/*.c++) \
             $$quote($$BASEDIR/../src/*.cc) \
             $$quote($$BASEDIR/../src/*.cpp) \
             $$quote($$BASEDIR/../src/*.cxx) \
             $$quote($$BASEDIR/../src/controller/*.c) \
             $$quote($$BASEDIR/../src/controller/*.c++) \
             $$quote($$BASEDIR/../src/controller/*.cc) \
             $$quote($$BASEDIR/../src/controller/*.cpp) \
             $$quote($$BASEDIR/../src/controller/*.cxx) \
             $$quote($$BASEDIR/../src/model/*.c) \
             $$quote($$BASEDIR/../src/model/*.c++) \
             $$quote($$BASEDIR/../src/model/*.cc) \
             $$quote($$BASEDIR/../src/model/*.cpp) \
             $$quote($$BASEDIR/../src/model/*.cxx) \
             $$quote($$BASEDIR/../assets/*.qml) \
             $$quote($$BASEDIR/../assets/*.js) \
             $$quote($$BASEDIR/../assets/*.qs) \
             $$quote($$BASEDIR/../assets/720x1280/*.qml) \
             $$quote($$BASEDIR/../assets/720x1280/*.js) \
             $$quote($$BASEDIR/../assets/720x1280/*.qs) \
             $$quote($$BASEDIR/../assets/720x1280/images/*.qml) \
             $$quote($$BASEDIR/../assets/720x1280/images/*.js) \
             $$quote($$BASEDIR/../assets/720x1280/images/*.qs) \
             $$quote($$BASEDIR/../assets/720x720/*.qml) \
             $$quote($$BASEDIR/../assets/720x720/*.js) \
             $$quote($$BASEDIR/../assets/720x720/*.qs) \
             $$quote($$BASEDIR/../assets/720x720/images/*.qml) \
             $$quote($$BASEDIR/../assets/720x720/images/*.js) \
             $$quote($$BASEDIR/../assets/720x720/images/*.qs) \
             $$quote($$BASEDIR/../assets/data/*.qml) \
             $$quote($$BASEDIR/../assets/data/*.js) \
             $$quote($$BASEDIR/../assets/data/*.qs) \
             $$quote($$BASEDIR/../assets/html/*.qml) \
             $$quote($$BASEDIR/../assets/html/*.js) \
             $$quote($$BASEDIR/../assets/html/*.qs) \
             $$quote($$BASEDIR/../assets/icons/*.qml) \
             $$quote($$BASEDIR/../assets/icons/*.js) \
             $$quote($$BASEDIR/../assets/icons/*.qs) \
             $$quote($$BASEDIR/../assets/images/*.qml) \
             $$quote($$BASEDIR/../assets/images/*.js) \
             $$quote($$BASEDIR/../assets/images/*.qs) \
             $$quote($$BASEDIR/../assets/js/*.qml) \
             $$quote($$BASEDIR/../assets/js/*.js) \
             $$quote($$BASEDIR/../assets/js/*.qs)

    HEADERS +=  $$quote($$BASEDIR/../src/*.h) \
             $$quote($$BASEDIR/../src/*.h++) \
             $$quote($$BASEDIR/../src/*.hh) \
             $$quote($$BASEDIR/../src/*.hpp) \
             $$quote($$BASEDIR/../src/*.hxx)
}

TRANSLATIONS =  $$quote($${TARGET}_es.ts) \
         $$quote($${TARGET}_fr.ts) \
         $$quote($${TARGET}_it.ts) \
         $$quote($${TARGET}_pt.ts) \
         $$quote($${TARGET}_pt_BR.ts) \
         $$quote($${TARGET}.ts)
