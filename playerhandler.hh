#ifndef PLAYERHANDLER_HH
#define PLAYERHANDLER_HH

#include "player.hh"
#include "playerinfo.hh"
#include "appobjecthandler.hh"
class AppWindow;

////////////////////////////////////////////////////////////////////////////////
///
/// This class owns and manipulates Player-objects. It inherits the
/// AppObjectHandler superclass that includes pre-implemented functions for
/// convenience. Note that the superclass does not have a container for the
/// AppObjects and it must be implemented within this subclass.
///
////////////////////////////////////////////////////////////////////////////////

class PlayerHandler : public AppObjectHandler
{
    Q_OBJECT

public:
    /***************************************************************************
     * CONSTRUCTOR AND DESTRUCTOR
     */
    /**
     * @brief Constructs a new PlayerHandler with access to the given window,
     * preloaded with the given components and possibly with a given parent.
     * @param window
     * @param components
     * @param parent
     */
    PlayerHandler(AppWindow* window, QString rootPath, QObject* parent = 0);
    /**
     */
    ~PlayerHandler();

    /***************************************************************************
     * PROPERTIES
     */
    Q_PROPERTY(bool doneOnce READ getDoneOnce WRITE setDoneOnce NOTIFY doneOnceChanged)
        bool getDoneOnce() const         {return m_doneOnce;}
        void setDoneOnce(bool doneOnce)   {m_doneOnce = doneOnce; emit doneOnceChanged();}
    Q_PROPERTY(bool canEdit READ getCanEdit WRITE setCanEdit NOTIFY canEditChanged)
        bool getCanEdit() const         {return m_canEdit;}
        void setCanEdit(bool canEdit)   {m_canEdit = canEdit; emit canEditChanged();}
    Q_PROPERTY(bool rememberPlayers READ getRememberPlayers WRITE setRememberPlayers NOTIFY rememberPlayersChanged)
        bool getRememberPlayers() const                 {return m_rememberPlayers;}
        void setRememberPlayers(bool rememberPlayers)   {m_rememberPlayers = rememberPlayers; emit rememberPlayersChanged();}
    Q_PROPERTY(int roundNumber READ getRoundNumber NOTIFY roundNumberChanged)
        int getRoundNumber() const      {return m_roundNumber;}
        void setRoundNumber(int roundNumber) {m_roundNumber = roundNumber; emit roundNumberChanged();}
    Q_PROPERTY(int xMin READ getXMin WRITE setXMin NOTIFY xMinChanged)
        void setXMin(int xMin) {m_xMin = xMin; emit xMinChanged();}
        int getXMin() const {return m_xMin;}
    Q_PROPERTY(int xMax READ getXMax WRITE setXMax NOTIFY xMaxChanged)
        void setXMax(int xMax) {m_xMax = xMax; emit xMaxChanged();}
        int getXMax() const {return m_xMax;}
    Q_PROPERTY(int yMax READ getYMax WRITE setYMax NOTIFY yMaxChanged)
        void setYMax(int yMax) {m_yMax = yMax; emit yMaxChanged();}
        int getYMax() const {return m_yMax;}
    Q_PROPERTY(QQmlListProperty<PlayerInfo> storedPlayers READ getStoredPlayers NOTIFY storedPlayersChanged)
        QQmlListProperty<PlayerInfo> getStoredPlayers() {return QQmlListProperty<PlayerInfo>(this, m_playerInfoList);}
    Q_PROPERTY(QQmlListProperty<Player> players READ getPlayers NOTIFY playersChanged)
        QQmlListProperty<Player> getPlayers() {return QQmlListProperty<Player>(this, m_playerList);}
    Q_PROPERTY(QQmlListProperty<Data> roundNumbers READ getRoundNumbers NOTIFY roundNumbersChanged)
        QQmlListProperty<Data> getRoundNumbers() {return QQmlListProperty<Data>(this, m_roundNumbers);}

    /***************************************************************************
     * INVOKABLES
     */
    Q_INVOKABLE bool storePlayer(QString name, bool remember);
    Q_INVOKABLE bool unstorePlayer(QString name);
    Q_INVOKABLE bool updatePlayers();
    Q_INVOKABLE void setIndex(QString name);
    Q_INVOKABLE void removeIndex(int index, QString name);
    Q_INVOKABLE void restart();

    /***************************************************************************
     * PUBLIC FUNCTIONS
     */
    bool isPlayerOnGame(QString name);
    bool loadStoredPlayers();
    void updateRoundNumber(int roundNumber);
    bool canAddScore(int roundNumber);
    bool savePlayers();

public slots:
    /***************************************************************************
     * SLOTS
     */
    void updateStatus();
    void updateHistograms();

signals:
    /***************************************************************************
     * SIGNALS
     */
    void canEditChanged();
    void roundNumbersChanged();
    void rememberPlayersChanged();
    void xMinChanged();
    void xMaxChanged();
    void yMaxChanged();
    void playersChanged();
    void storedPlayersChanged();
    void doneOnceChanged();
    void roundNumberChanged();

private:
    /***************************************************************************
     * PRIVATE FUNCTIONS
     */
    Player* getPlayer(QString name);

    /***************************************************************************
     * PRIVATE VARIABLES
     */
    int m_roundNumber;
    int m_xMin;
    int m_xMax;
    int m_yMax;
    int m_nPlayers;
    bool m_firstRound;
    bool m_canEdit;                      ///< Can the scores of previous rounds be edited
    bool m_doneOnce;
    bool m_rememberPlayers;              ///< Should the newly created players be permanently stored
    bool m_needSaving;
    QList<Player*> m_playerList;            ///< A list that contains the dynamically created AppObjects.
    QMap<QString, Player*> m_playerMap;
    QList<PlayerInfo*> m_playerInfoList;  ///< List containing the names of stored players
    QMap<QString, PlayerInfo*> m_playerInfoMap;
    QList<Data*> m_roundNumbers;         ///< Stores the roundNumbers
    QList<QString> m_playerOrder;        ///< Selected players in order
    QObject *m_toast;
    QString m_rootPath;
    QSet<QString> m_removedPlayers;

};

#endif // PLAYERHANDLER_HH
