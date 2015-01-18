#ifndef PLAYER_HH
#define PLAYER_HH

#include "appobject.hh"
//#include "playerhandler.hh"
class Data;
class PlayerHandler;

////////////////////////////////////////////////////////////////////////////////
///
/// This class represents players in the game and stores their information. This
/// class inherits the AppObject-superclass because the visual elements related
/// to the players are also handled by this class.
///
////////////////////////////////////////////////////////////////////////////////

class Player : public AppObject
{
    Q_OBJECT

public:
    /***************************************************************************
     * CONSTRUCTOR AND DESTRUCTOR
     */
    /**
     * @brief Constructs the Player in the given window, with the given name and
     * index.
     * It is also owned by the given handler.
     * @param The window that displays everything
     * @param Name of the player
     * @param Index of the player
     * @param The handler that owns this player
     */
    Player(AppWindow* window=0, const QString& name="", int index=0, PlayerHandler* handler=0);
    /**
     * @brief Destroys the dynamically allocated scores (QQuickItems)
     */
    ~Player();

    /***************************************************************************
     * PROPERTIES
     */
    Q_PROPERTY(QString name READ getName NOTIFY nameChanged)
        QString getName() const { return m_name;}
        void setName(QString name);
    Q_PROPERTY(int index READ getIndex NOTIFY indexChanged)
        void setIndex(int index);
        int getIndex() const;
    Q_PROPERTY(int totalScore READ getTotalScore NOTIFY totalScoreChanged)
        int getTotalScore() const;
        void setTotalScore(int totalScore);
    Q_PROPERTY(int rank READ getRank NOTIFY rankChanged)
        void setRank(int rank);
        int getRank() const;
    Q_PROPERTY(int pseudoRank READ getPseudoRank NOTIFY pseudoRankChanged)
        void setPseudoRank(int pseudoRank);
        int getPseudoRank() const;
    Q_PROPERTY(int max READ getMax NOTIFY maxChanged)
        void setMax(int max) {m_max = max; emit maxChanged();}
        int getMax() const {return m_max;}
    Q_PROPERTY(int min READ getMin NOTIFY minChanged)
        void setMin(int min) {m_min = min; emit minChanged();}
        int getMin() const {return m_min;}
    Q_PROPERTY(float average READ getAverage NOTIFY averageChanged)
        void setAverage(float average) {m_average = average; emit averageChanged();}
        float getAverage() const {return m_average;}
    Q_PROPERTY(float std READ getStd NOTIFY stdChanged)
        void setStd(float std) {m_std = std; emit stdChanged();}
        float getStd() const {return m_std;}
    Q_PROPERTY(float winner READ getWinner NOTIFY winnerChanged)
        void setWinner(bool winner) {m_winner = winner; emit winnerChanged();}
        bool getWinner() const {return m_winner;}
    Q_PROPERTY(float loser READ getLoser NOTIFY loserChanged)
        void setLoser(bool loser) {m_loser = loser; emit loserChanged();}
        bool getLoser() const {return m_loser;}
    Q_PROPERTY(int roundNumber READ getRoundNumber NOTIFY roundNumberChanged)
        int getRoundNumber() const      {return m_roundNumber;}
    Q_PROPERTY(QQmlListProperty<Data> histogram READ getHistogram NOTIFY histogramChanged)
        QQmlListProperty<Data> getHistogram() {return QQmlListProperty<Data>(this, m_histogram);}
    Q_PROPERTY(QQmlListProperty<Data> scores READ getScores NOTIFY scoresChanged)
        QQmlListProperty<Data> getScores() {return QQmlListProperty<Data>(this, m_scores);}

    /***************************************************************************
     * INVOKABLES
     */
     Q_INVOKABLE void addScore(int score);

    /***************************************************************************
     * PUBLIC FUNCTIONS
     */
    void setRoundScore(QString score);
    void setRoundNumber(int roundNumber);
    std::pair<bool, int> getRoundScore() const;
    int updateHistogram(int min, int max, int nBins);
    void removeScores();

    /***************************************************************************
     * PUBLIC VARIABLES
     */
    int m_index;
    int m_totalScore;
    float m_average;
    float m_std;
    int m_min;
    int m_max;
    int m_rank;
    int m_pseudoRank;
    int m_roundNumber;
    bool m_winner;
    bool m_loser;
    QString m_name;
    QList<Data*> m_scores;
    QList<Data*> m_histogram;

public slots:
    /***************************************************************************
     * SLOTS
     */
    void updateScoreInformation();

signals:
    /***************************************************************************
     * SIGNALS
     */
    void updateStatus();
    void nameChanged();
    void indexChanged();
    void totalScoreChanged();
    void rankChanged();
    void pseudoRankChanged();
    void histogramChanged();
    void minChanged();
    void maxChanged();
    void averageChanged();
    void stdChanged();
    void scoresChanged();
    void winnerChanged();
    void loserChanged();
    void roundNumberChanged();

private:
    /***************************************************************************
     * PRIVATE VARIABLES
     */
    PlayerHandler* m_playerHandler;
};

#endif // PLAYER_HH
