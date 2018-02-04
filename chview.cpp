#include "chview.h"
#include <QGridLayout>
#include <QLabel>

ChView::ChView(const QString &title, chinfo *pCh) : QDockWidget(title)
{
   setAttribute(Qt::WA_DeleteOnClose);

   addControls();

}

void ChView::addControls()
{
   QPushButton *m_pGo = new QPushButton;
   m_pGo->setText("Transfer");
   QLineEdit *m_signalFreq = new QLineEdit;
   QLineEdit *m_dataRate   = new QLineEdit;

   QGridLayout * pLayout = new QGridLayout;

   pLayout->addWidget(new QLabel("Freq"),0,0);
   pLayout->addWidget(m_signalFreq,0,1);

   pLayout->addWidget(new QLabel("Rate"),1,0);
   pLayout->addWidget(m_dataRate,1,1);

   pLayout->addWidget(m_pGo,2,1);

   QWidget* wrapper = new QWidget();
   wrapper->setLayout(pLayout);

   setWidget(wrapper);

}
