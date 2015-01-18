#ifndef GAME_H
#define GAME_H

#include "appwindow.hh"
#include "playerhandler.hh"
#include <QtGui/QGuiApplication>
#include <QFile>
#include "player.hh"
#include "data.hh"
#include <QObject>

////////////////////////////////////////////////////////////////////////////////
///
///
///
////////////////////////////////////////////////////////////////////////////////

class Game : public QObject
{
    Q_OBJECT

public:
    /***************************************************************************
     * CONSTRUCTOR AND DESTRUCTOR
     */
    explicit Game(QObject *parent = 0);
    ~Game();

    /***************************************************************************
     * PROPERTIES
     */

    /***************************************************************************
     * INVOKABLES
     */

    /***************************************************************************
     * PUBLIC FUNCTIONS
     */

signals:
    /***************************************************************************
     * SIGNALS
     */
    void gamesChanged();

public slots:
    /***************************************************************************
     * SLOTS
     */
    void saveSettings();

private:
    /***************************************************************************
     * PRIVATE FUNCTIONS
     */
    void loadSettings();

    /***************************************************************************
     * PRIVATE VARIABLES
     */
    AppWindow* m_window;
    PlayerHandler* m_playerHandler;
    QString m_rootPath;
};

#endif // GAME_H
