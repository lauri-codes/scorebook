#include "game.hh"
#include "playerinfo.hh"
#include <QQmlContext>
#include <QQmlEngine>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonParseError>
#include <QDir>

/***************************************************************************
 * CONSTRUCTOR AND DESTRUCTOR
 */
Game::Game(QObject* parent)
    : QObject(parent)
{
    // Register the datatypes that are exchanged with QLists to QML
    qmlRegisterType<Data>("com.mycompany.messaging", 1, 0, "Data");
    qmlRegisterType<PlayerInfo>("com.mycompany.messaging", 1, 0, "PlayerInfo");
    qmlRegisterType<Player>("com.mycompany.messaging", 1, 0, "Player");

    // Save settings on exit
    QObject::connect(qApp, SIGNAL(aboutToQuit()), this, SLOT(saveSettings()));

    m_window = new AppWindow("qml/", "MainView.qml", QSize(420, 747));
    m_window->showAppWindow();
    m_window->engine()->rootContext()->setContextProperty("game", this);

    // Solve the root directory
    #if defined(Q_OS_ANDROID)
        m_rootPath = "/sdcard/ScoreBook";
    #else
        m_rootPath = "../ScoreBook";
    #endif

    // Create directory if necessary
    if (!QDir(m_rootPath).exists())
    {
        QDir().mkdir(m_rootPath);
    }

    m_playerHandler = new PlayerHandler(m_window, m_rootPath);
    m_playerHandler->loadStoredPlayers();
    loadSettings();
}

Game::~Game()
{
    delete m_playerHandler;
    delete m_window;
}

/***************************************************************************
 * PROPERTIES
 */

/***************************************************************************
 * INVOKABLES
 */

/***************************************************************************
 * PRIVATE FUNCTIONS
 */
void Game::loadSettings()
{
    // Check for file
    QString fileName = m_rootPath + "/settings.json";
    QFile file(fileName);
    if (!file.open(QIODevice::ReadOnly))
    {
        qWarning() << Q_FUNC_INFO << ": unknown filename: "+fileName;
        return;
    }

    //Read the file
    QJsonParseError error;
    QByteArray settingsData = file.readAll();
    QJsonDocument jsonDocument = QJsonDocument::fromJson(settingsData, &error);

    if (error.error != QJsonParseError::NoError)
    {
        qWarning() << Q_FUNC_INFO << ": Error parsing the JSON-file";
        qWarning() << "Error message: " << error.errorString();
    }

    //Start decoding properties
    QJsonObject settings = jsonDocument.object();
    bool storePlayers = settings["storePlayers"].toBool();
    bool editScores = settings["editScores"].toBool();
    m_playerHandler->setRememberPlayers(storePlayers);
    m_playerHandler->setCanEdit(editScores);
}

void Game::saveSettings()
{
    // Save game settings
    QString fileName = m_rootPath + "/settings.json";
    QFile file(fileName);
    if (!file.open(QIODevice::WriteOnly))
    {
        qWarning() << Q_FUNC_INFO << ": unknown filename: "+fileName;
        return;
    }
    QJsonObject settingsObject;
    settingsObject["storePlayers"] = m_playerHandler->getRememberPlayers();
    settingsObject["editScores"] = m_playerHandler->getCanEdit();
    QJsonDocument saveDoc(settingsObject);
    file.resize(0);
    file.write(saveDoc.toJson());

    // Save players
    m_playerHandler->savePlayers();
}
