#include "playerinfo.hh"

/*******************************************************************************
 * CONSTRUCTORS
 */
PlayerInfo::PlayerInfo(QString name, bool onGame, bool remember, QObject* parent)
    : QObject(parent)
    , m_name(name)
    , m_selected(onGame)
    , m_remember(remember)
    , m_index(-1)
{
}
PlayerInfo::PlayerInfo(QObject* parent)
    : QObject(parent)
    , m_name("")
    , m_selected(false)
    , m_remember(false)
    , m_index(-1)
{
}
