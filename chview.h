#ifndef CHVIEW_H
#define CHVIEW_H

#include <QObject>
#include <QWidget>
#include <QDockWidget>
#include <QLineEdit>
#include <QPushButton>

class ChView : public QDockWidget
{
public:
   ChView(const QString& title);

private:
   void addControls(void);

   QPushButton *m_pGo;
   QLineEdit *m_signalFreq;
   QLineEdit *m_dataRate;
};

#endif // CHVIEW_H
