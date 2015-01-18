TEMPLATE = app
QT += qml quick svg

# Default rules for deployment.
include(deployment.pri)

# Add support to C++11
CONFIG += c++11

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += \
    playerhandler.cc \
    player.cc \
    playerinfo.cc \
    main.cc \
    game.cc

HEADERS += \
    playerhandler.hh \
    player.hh \
    playerinfo.hh \
    game.hh \
    data.hh

# Add the app library
include(../app/app.pri)

RESOURCES += \
    misc.qrc \
    qml.qrc \
    images.qrc

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

OTHER_FILES += \
    android/AndroidManifest.xml
