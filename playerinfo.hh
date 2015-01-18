#ifndef PLAYERINFO_HH
#define PLAYERINFO_HH

#include <QObject>
#include <QDebug>

////////////////////////////////////////////////////////////////////////////////
///
///
////////////////////////////////////////////////////////////////////////////////

class PlayerInfo : public QObject
{
    Q_OBJECT

/******************************************************************************/
public:
    PlayerInfo(QString name, bool onGame=true, bool remember=false, QObject* parent = 0);
    PlayerInfo(QObject* parent = 0);

    Q_PROPERTY(QString name READ getName NOTIFY nameChanged)
        QString getName() const { return m_name;}
        void setName(QString name) { m_name = name; emit nameChanged();}
    Q_PROPERTY(bool onGame READ getSelected WRITE setSelected NOTIFY selectedChanged)
        bool getSelected() const { return m_selected;}
        void setSelected(bool onGame) { m_selected = onGame; emit selectedChanged();}
    Q_PROPERTY(int qmlIndex READ getIndex NOTIFY indexChanged)
        int getIndex() const { return m_index;}
        void setIndex(int index) { m_index = index; emit indexChanged();}

    QString m_name;
    bool m_selected;
    bool m_remember;
    int m_index;

/******************************************************************************/
signals:
    void nameChanged();
    void selectedChanged();
    void indexChanged();
};

#endif // PLAYERINFO_HH
