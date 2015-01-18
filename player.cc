#include "player.hh"
#include "playerhandler.hh"
#include "data.hh"
#include <QDebug>
#include <qmath.h>

/*******************************************************************************
 * CONSTRUCTOR AND DESTRUCTOR
 */
Player::Player(AppWindow* window, const QString& playerName, int index, PlayerHandler* handler)
    : AppObject(window, qobject_cast<AppObjectHandler*>(handler))
    , m_totalScore(0)
    , m_average(0)
    , m_std(0)
    , m_min(0)
    , m_max(0)
    , m_rank(0)
    , m_pseudoRank(0)
    , m_roundNumber(1)
    , m_playerHandler(handler)
{
    setName(playerName);
    setIndex(index);
}
Player::~Player()
{
    qDeleteAll(m_scores);
    qDeleteAll(m_histogram);
}
/*******************************************************************************
 * PROPERTIES
 */
void Player::setName(QString name)
{
    m_name = name;
    emit nameChanged();
}

void Player::setIndex(int index)
{
    m_index = index;
    emit indexChanged();
}

int Player::getIndex() const
{
    return m_index;
}

int Player::getTotalScore() const
{
    return m_totalScore;
}

void Player::setTotalScore(int totalScore)
{
    m_totalScore = totalScore;
    emit totalScoreChanged();
}

int Player::getRank() const
{
    return m_rank;
}

void Player::setRank(int rank)
{
    m_rank = rank;
    emit rankChanged();
}

void Player::setPseudoRank(int pseudoRank)
{
    m_pseudoRank = pseudoRank;
    emit pseudoRankChanged();
}

int Player::getPseudoRank() const
{
    return m_pseudoRank;
}

/*******************************************************************************
 * INVOKABLES
 */
void Player::addScore(int score)
{
    Data* data = new Data(score);
    // If the scores are later on edited, update all necessary parts through signals
    connect(data, SIGNAL(valueChanged()), this, SLOT(updateScoreInformation()));
    connect(data, SIGNAL(valueChanged()), parent(), SLOT(updateHistograms()));
    connect(data, SIGNAL(valueChanged()), parent(), SLOT(updateStatus()));
    m_scores.append(data);
    emit scoresChanged();

    updateScoreInformation();
    ++m_roundNumber;
    emit roundNumberChanged();
    m_playerHandler->updateRoundNumber(m_roundNumber);
    emit updateStatus();
}
/*******************************************************************************
 * PUBLIC FUNCTIONS
 */
void Player::setRoundNumber(int roundNumber)
{
    for (int counter = 1; counter < roundNumber; ++counter)
    {
        m_scores.append(new Data(0));
    }
    emit scoresChanged();
    m_roundNumber = roundNumber;
    emit roundNumberChanged();
}


int Player::updateHistogram(int min, int max, int nBins)
{
    // If bin size has changed, empty the current data and create new bins
    QList<Data*> bins;
    if (m_histogram.size() != nBins)
    {
        qDeleteAll(m_histogram);
        m_histogram.clear();
        for (int bin = 0; bin < nBins; ++bin)
        {
            bins.append(new Data(0));
        }
        m_histogram = bins;
    }

    // Zero out the current histogram
    for (auto iter = m_histogram.begin(); iter != m_histogram.end(); ++iter)
    {
        (*iter)->setValue(0);
    }

    // Fill the bins
    float binSize = (max-min)/float(nBins);
    int yMax = 0;
    int counter = 0;
    for (Data* score : m_scores)
    {
        float remaining = score->getValue() - min;
        int bin = qFloor(remaining/binSize);
        if (bin == m_histogram.size())
        {
            bin -= 1;
        }
        //qDebug() << bin;
        int currValue = m_histogram[bin]->getValue();
        int newValue = currValue + 1;
        if (counter == 0 || newValue > yMax)
        {
            yMax = newValue;
        }
        m_histogram[bin]->setValue(newValue);
        ++counter;
    }
    emit histogramChanged();
    return yMax;
}

void Player::updateScoreInformation()
{
    // Update the statistics and the total score in one loop
    int totalScore = 0;
    int size = m_scores.size();
    int min = 0;
    int max = 0;

    for (auto iter = m_scores.begin(); iter != m_scores.end(); ++iter)
    {
        int score = (*iter)->getValue();
        totalScore += score;
        if (size == 1)
        {
            min = score;
            max = score;
        }
        else
        {
            if (score < min)
            {
                min = score;
            }
            if (score > max)
            {
                max = score;
            }
        }
    }
    setTotalScore(totalScore);
    if (size != 0)
    {
        setAverage(totalScore/(float)size);
    }
    else
    {
        setAverage(0);
    }
    setMin(min);
    setMax(max);
}
void Player::removeScores()
{
    for (Data* score : m_scores)
    {
        score->deleteLater();
    }
    m_scores.clear();
    updateScoreInformation();
    setRoundNumber(1);
    emit scoresChanged();
}
