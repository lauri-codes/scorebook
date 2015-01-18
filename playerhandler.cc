#include "playerhandler.hh"
#include "appwindow.hh"
#include "data.hh"
#include <QDebug>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlIncubator>
#include <QCoreApplication>
#include <QQmlEngine>
#include <QQmlIncubationController>
#include <QtQml>
#include <QtAlgorithms>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonParseError>
#include "playerinfo.hh"

bool sortFunction(std::pair<int,int> i, std::pair<int,int> j)
{
    return (i.second > j.second );
}
/***************************************************************************
 * CONSTRUCTOR AND DESTRUCTOR
 */
PlayerHandler::PlayerHandler(AppWindow *window, QString rootPath, QObject *parent)
    : AppObjectHandler(window, parent)
    , m_roundNumber(1)
    , m_xMin(0)
    , m_xMax(0)
    , m_yMax(0)
    , m_nPlayers(0)
    , m_firstRound(true)
    , m_canEdit(false)
    , m_doneOnce(false)
    , m_rememberPlayers(true)
    , m_needSaving(false)
    , m_rootPath(rootPath)
{
    m_window->engine()->rootContext()->setContextProperty("playerHandler", this);
    m_toast = m_window->getByObjectName("toast");
}

PlayerHandler::~PlayerHandler()
{
    qDeleteAll(m_playerList);
    qDeleteAll(m_playerInfoList);
    qDeleteAll(m_roundNumbers);
}
/***************************************************************************
 * INVOKABLES
 */
void PlayerHandler::updateRoundNumber(int roundNumber)
{
    if (roundNumber == m_roundNumber + 1)
    {
        int minRound = m_playerList[0]->getRoundNumber();
        for (Player* player : m_playerList)
        {
            int round = player->getRoundNumber();
            if (round < minRound)
            {
                minRound = round;
            }
        }
        m_roundNumber = minRound;
        emit roundNumberChanged();
    }
}

bool PlayerHandler::canAddScore(int roundNumber)
{
    for (Player* player : m_playerList)
    {
        int pRound = player->m_roundNumber;
        if (pRound < roundNumber)
        {
            QMetaObject::invokeMethod(m_toast, "showPopup", Q_ARG(QVariant, "Please input all player scores\nfor the current round first"));
            return false;
        }
    }
    return true;
}

bool PlayerHandler::updatePlayers()
{
    // Remove unselected players, add new selected ones

    bool changed = false;
    QList<Player*> newPlayers;
    newPlayers.reserve(m_nPlayers);

    // First check that have any players been selected
    bool playersSelected = false;
    for (PlayerInfo* player : m_playerInfoList)
    {
        if (player->getSelected())
        {
            playersSelected = true;
        }
    }
    if (!playersSelected)
    {
        return false;
    }

    // Now update the player list
    for (PlayerInfo* player : m_playerInfoList)
    {
        QString name = player->getName();
        bool selected = player->getSelected();
        bool onGame = isPlayerOnGame(name);
        int index = player->getIndex();

        // New players
        if (selected && !onGame)
        {
            Player* newPlayer = new Player(m_window, name, index, this);
            newPlayer->setRoundNumber(m_roundNumber);
            connect(newPlayer, SIGNAL(updateStatus()), this, SLOT(updateStatus()));
            m_playerMap.insert(name, newPlayer);
            newPlayers.insert(index, newPlayer);
            playersSelected = true;
            changed = true;
        }
        // Removed players
        else if (!selected && onGame) {
            m_playerMap[name]->deleteLater();
            m_playerMap.remove(name);
            changed = true;
        }
        // Unchanged players
        else if (selected && onGame)
        {
            Player* unchanged = m_playerMap[name];
            newPlayers.insert(index, unchanged);
        }
    }
    if (changed)
    {
        m_playerList = newPlayers;
        emit playersChanged();
        updateStatus();
        //updateHistograms();
    }
    return playersSelected;
}

void PlayerHandler::setIndex(QString name)
{
    m_playerInfoMap[name]->setIndex(m_nPlayers);
    ++m_nPlayers;
}

void PlayerHandler::removeIndex(int index, QString name)
{
    m_playerInfoMap[name]->setIndex(-1);
    for (PlayerInfo* info : m_playerInfoMap.values())
    {
        int pIndex = info->getIndex();
        if (pIndex > index)
        {
            info->setIndex(pIndex-1);
        }
    }
    --m_nPlayers;
}
void PlayerHandler::restart()
{
    for (Player* player : m_playerList)
    {
        player->removeScores();
    }
    setRoundNumber(1);
    updateStatus();
}

/***************************************************************************
 * PUBLIC FUNCTIONS
 */
bool PlayerHandler::isPlayerOnGame(QString name)
{
    return m_playerMap.contains(name);
}

Player* PlayerHandler::getPlayer(QString name)
{
    if (m_playerMap.contains(name))
    {
        return m_playerMap[name];
    }
    else
    {
        return 0;
    }
}

bool PlayerHandler::loadStoredPlayers()
{
    // Check for file
    QString fileName = m_rootPath + "/players.json";
    QFile file(fileName);
    if (!file.open(QIODevice::ReadWrite))
    {
        qWarning() << Q_FUNC_INFO << ": unknown filename: "+fileName;
        return false;
    }
    // Store the existing players to list
    QJsonParseError error;
    QByteArray fileContents = file.readAll();
    QJsonDocument jsonDocument;
    QJsonArray playerList;
    if (!fileContents.isNull())
    {
        jsonDocument = QJsonDocument::fromJson(fileContents, &error);
        if (error.error != QJsonParseError::NoError)
        {
            qWarning() << Q_FUNC_INFO << ": Error parsing the JSON-file";
            qWarning() << "Error message: " << error.errorString();
            file.resize(0);
            return false;
        }
        playerList = jsonDocument.array();
    }
    file.close();

    //Start decoding properties
    for (auto iter = playerList.begin(); iter != playerList.end(); ++iter)
    {
        QJsonObject player = (*iter).toObject();
        QString name = (*player.find("name")).toString();
        PlayerInfo* playerInfo = new PlayerInfo(name,false);
        m_playerInfoList.push_back(playerInfo);
        m_playerInfoMap.insert(name, playerInfo);
    }
    emit storedPlayersChanged();
    return true;
}

bool PlayerHandler::storePlayer(QString name, bool remember)
{
    // Check if the player is already stored
    if (m_playerInfoMap.contains(name))
    {
        m_playerInfoMap[name]->setSelected(true);
    }
    else
    {
        // Add the player to current list
        if (remember) {
            m_needSaving = true;
        }
        PlayerInfo* info = new PlayerInfo(name, true, remember);
        info->setIndex(m_nPlayers);
        ++m_nPlayers;
        m_playerInfoList.push_back(info);
        m_playerInfoMap.insert(name, info);

        emit storedPlayersChanged();
        return true;
    }
    return false;
}

bool PlayerHandler::unstorePlayer(QString name)
{
    // Add player name to set. The players in this set are removed on
    // application exit.
    m_needSaving = true;
    m_removedPlayers.insert(name);

    //Update the stored players list
    m_playerInfoMap[name]->setSelected(false);
    int index = m_playerInfoMap[name]->getIndex();
    removeIndex(index, name);
    updatePlayers();
    for (auto iter = m_playerInfoList.begin(); iter != m_playerInfoList.end(); ++iter)
    {
        if ((*iter)->getName() == name)
        {
            (*iter)->deleteLater();
            m_playerInfoList.erase(iter);
            m_playerInfoMap.remove(name);
            emit storedPlayersChanged();
            break;
        }
    }
    return true;
}

void PlayerHandler::updateStatus()
{
    // Calculate new statuses
    int highestScore = m_playerList[0]->m_totalScore;
    int lowestScore = highestScore;
    Player* winner = m_playerList[0];
    Player* loser = m_playerList[0];

    QList<std::pair<int,int>> indexAndScore;

    for (int index = 0; index < m_playerList.size(); ++index)
    {
        Player* currentPlayer = m_playerList[index];
        currentPlayer->setWinner(false);
        currentPlayer->setLoser(false);
        int currentScore = currentPlayer->m_totalScore;
        if (currentScore > highestScore)
        {
            highestScore = currentScore;
            winner = currentPlayer;
        }
        if (currentScore < lowestScore)
        {
            lowestScore = currentScore;
            loser = currentPlayer;
        }
        std::pair<int,int> pair = std::make_pair(index, currentScore);
        indexAndScore.push_back(pair);
    }
    winner->setWinner(true);
    loser->setLoser(true);

    // Update the ranks
    qSort(indexAndScore.begin(), indexAndScore.end(), sortFunction);
    int rank = 1;
    int pseudoRank = 1;
    int previousScore = indexAndScore[0].second;
    for (auto iter = indexAndScore.begin(); iter != indexAndScore.end(); ++iter)
    {
        int currentScore = iter->second;
        if (currentScore != previousScore)
        {
            ++pseudoRank;
        }
        previousScore = currentScore;
        m_playerList[iter->first]->setPseudoRank(pseudoRank);
        m_playerList[iter->first]->setRank(rank);
        ++rank;
    }
}
/***************************************************************************
 * PRIVATE FUNCTIONS
 */
bool PlayerHandler::savePlayers()
{
    if (m_needSaving) {
        // Open the file
        QString fileName = m_rootPath + "/players.json";

        QFile file(fileName);
        if (!file.open(QIODevice::ReadWrite))
        {
            qWarning() << Q_FUNC_INFO << ": unknown filename: " + fileName;
            return false;
        }
        //Convert the file to JsonDoc
        QJsonParseError error;
        QByteArray fileContents = file.readAll();

        // Store the existing players to list
        QJsonDocument jsonDocument;
        QJsonArray playerList;
        if (!fileContents.isNull())
        {
            jsonDocument = QJsonDocument::fromJson(fileContents, &error);
            if (error.error != QJsonParseError::NoError)
            {
                qWarning() << Q_FUNC_INFO << ": Error parsing the JSON-file";
                qWarning() << "Error message: " << error.errorString();
                return false;
            }
            playerList = jsonDocument.array();
        }
        // Add new players to the list
        for (PlayerInfo* info : m_playerInfoList)
        {
            bool remember = info->m_remember;
            if (remember)
            {
                QJsonObject newPlayer;
                newPlayer.insert("name", info->m_name);
                playerList.push_back(newPlayer);
            }
        }
        // Remove removed players
        for (auto iter = playerList.begin(); iter != playerList.end();)
        {
            QJsonObject player = (*iter).toObject();
            QString name = (*player.find("name")).toString();
            if (m_removedPlayers.contains(name))
            {
                iter = playerList.erase(iter);
            }
            else
            {
                ++iter;
            }
        }

        QJsonDocument modded = QJsonDocument(playerList);
        QByteArray array = modded.toJson();

        // The previous contents are deleted, write position is set to
        // beginning, contents are written. It is important to delete previous
        // contents if new contents are shorter!
        file.resize(0);
        file.seek(0);
        file.write(array);
    }
    return true;
}

void PlayerHandler::updateHistograms()
{
    int counter = 0;
    int min = 0;
    int max = 0;

    // Find out the global minimum and maximum score in the current game. They
    // are used to scale the histograms.
    for (auto iter = m_playerList.begin(); iter != m_playerList.end(); ++iter)
    {

        Player* player = qobject_cast<Player*>(*iter);
        int p_min = player->m_min;
        int p_max = player->m_max;

        if (counter == 0)
        {
            min = p_min;
            max = p_max;
        }
        else
        {
            if (p_min < min)
            {
                min = p_min;
            }
            if (p_max > max)
            {
                max = p_max;
            }
        }
        ++counter;
    }

    // If min and max are the same, use some special interval
    if (min == max)
    {
        int margin = qFloor(0.2*min);
        if (margin == 0)
        {
            margin = 10;
        }
        min = min - margin;
        max = max + margin;
    }
    setXMin(min);
    setXMax(max);

    // Update everyones histogram
    int yMax = 0;
    counter = 0;
    for (auto iter = m_playerList.begin(); iter != m_playerList.end(); ++iter)
    {
        Player* player = qobject_cast<Player*>(*iter);
        int p_yMax = player->updateHistogram(min, max, 15);
        if (counter == 0 || p_yMax > yMax)
        {
            yMax = p_yMax;
        }
        ++counter;
    }
    setYMax(yMax);
}
