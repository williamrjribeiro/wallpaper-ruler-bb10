# Auto-generated by IDE. Any changes made by user will be lost!
BASEDIR =  $$quote($$_PRO_FILE_PWD_)

device {
    CONFIG(release, debug|release) {
        SOURCES +=  $$quote($$BASEDIR/src/WallpaperRuler.cpp) \
                 $$quote($$BASEDIR/src/controller/AppLocalization.cpp) \
                 $$quote($$BASEDIR/src/controller/AppSettings.cpp) \
                 $$quote($$BASEDIR/src/controller/CameraManager.cpp) \
                 $$quote($$BASEDIR/src/controller/ImageLoader.cpp) \
                 $$quote($$BASEDIR/src/controller/ImageProcessor.cpp) \
                 $$quote($$BASEDIR/src/main.cpp) \
                 $$quote($$BASEDIR/src/model/ImageGridDataProvider.cpp)

        HEADERS +=  $$quote($$BASEDIR/src/WallpaperRuler.hpp) \
                 $$quote($$BASEDIR/src/controller/AppLocalization.h) \
                 $$quote($$BASEDIR/src/controller/AppSettings.hpp) \
                 $$quote($$BASEDIR/src/controller/CameraManager.hpp) \
                 $$quote($$BASEDIR/src/controller/ImageLoader.h) \
                 $$quote($$BASEDIR/src/controller/ImageProcessor.h) \
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
             $$quote($$BASEDIR/../assets/*.qml) \
             $$quote($$BASEDIR/../assets/*.js) \
             $$quote($$BASEDIR/../assets/*.qs)

    HEADERS +=  $$quote($$BASEDIR/../src/*.h) \
             $$quote($$BASEDIR/../src/*.h++) \
             $$quote($$BASEDIR/../src/*.hh) \
             $$quote($$BASEDIR/../src/*.hpp) \
             $$quote($$BASEDIR/../src/*.hxx)
}

TRANSLATIONS =  $$quote($${TARGET}.ts)
