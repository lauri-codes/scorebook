#ifndef DATA_HH
#define DATA_HH

#include <QObject>

////////////////////////////////////////////////////////////////////////////////
///
/// This class represents any numeric data that is placed on a QList and passed
/// to QML data containers
///
////////////////////////////////////////////////////////////////////////////////

class Data : public QObject
{
    Q_OBJECT

public:
    /***************************************************************************
     * CONSTRUCTORS
     */
    Data(QObject* parent=0)
        : QObject(parent)
        , m_value(0)
    {
    }
    Data(int value, QObject* parent=0)
        : QObject(parent)
        , m_value(value)
    {
    }
    /***************************************************************************
     * PROPERTIES
     */
    Q_PROPERTY(int value READ getValue WRITE setValue NOTIFY valueChanged)
        int getValue() const { return m_value;}
        void setValue(float value) { m_value = value; emit valueChanged();}

    /***************************************************************************
     * PUBLIC VARIABLES
     */
    int m_value;

signals:
    /***************************************************************************
     * SIGNALS
     */
    void valueChanged();
};
#endif // DATA_HH
