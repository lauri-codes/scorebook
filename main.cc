#include <QGuiApplication>
#include <QFile>
#include "appwindow.hh"
#include "playerhandler.hh"
#include "player.hh"
#include "data.hh"
#include "game.hh"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    Game game;
    return app.exec();
}
