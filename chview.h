#ifndef CHVIEW_H
#define CHVIEW_H

#include <QObject>
#include <QWidget>
#include <QDockWidget>
#include <QLineEdit>
#include <QPushButton>
#include <stdint.h>
#include "chinfo.h"

class ChView : public QDockWidget
{
public:
   ChView(const QString& title, chinfo* pCh);

private:
   void addControls(void);

   QPushButton *m_pGo;
   QLineEdit *m_signalFreq;
   QLineEdit *m_dataRate;
   chinfo    *m_pCh = nullptr;
};

#endif // CHVIEW_H
