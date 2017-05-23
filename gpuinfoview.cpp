#include "gpuinfoview.h"
#include <QWidget>
#include <QGridLayout>
#include <QLabel>

GPUInfoView::GPUInfoView(GPUInfo *pGPU) : m_pGPU(pGPU)
{
   addControls(m_pGPU->GetNumGPUs());
   if(m_pMsgBox)
   {
      m_pMsgBox->append("Line\t 1");
      m_pMsgBox->append("Line\t 2");
   }
}

void GPUInfoView::GPUPropUpdate(int gpuIdx)
{
   char buf[128];
   list<string> strlist;

   if(gpuIdx >= 0 && gpuIdx <= m_pGPU->GetNumGPUs())
   {
      strlist = m_pGPU->GetGPUProps(gpuIdx);
   }
   else
   {
      sprintf(buf, "Could not obtain GPU properties for index %d", gpuIdx);
      strlist.push_back(string(buf));
   }

   m_pMsgBox->clear();

   for(list<string>::iterator it = strlist.begin(); it != strlist.end(); ++it)
   {
      m_pMsgBox->append(QString::fromStdString(*it));

   }
}

void GPUInfoView::addControls(uint32_t nGPU)
{
   QGridLayout* pLayout = new QGridLayout;
   QWidget* w = new QWidget; // wrapper for layout to add to dock
   if(0 == nGPU)
   {
      // Simple message that there are no valid GPUs
      pLayout->addWidget(new QLabel("<No GPUs detected>"),1,1,1,1,Qt::AlignCenter | Qt::AlignHCenter);
   }
   else
   {
      uint32_t col = 1;
      uint32_t row = 1;
      pLayout->addWidget(new QLabel("GPU Properties "), row, col++);
      if(1 < nGPU)
      {
         m_pGpuSelect = new QSpinBox;
         m_pGpuSelect->setToolTip("Select GPU");
         m_pGpuSelect->setMinimum(0);
         m_pGpuSelect->setMaximum(nGPU - 1);
         m_pGpuSelect->setValue(1);
         connect(m_pGpuSelect, SIGNAL(valueChanged(int)), this, SLOT(GPUPropUpdate(int)));

         pLayout->addWidget(new QLabel("For GPU"), row, col++);

         pLayout->addWidget(m_pGpuSelect, row, col++);
      }
      row++;
      m_pMsgBox = new QTextEdit;
      pLayout->addWidget(m_pMsgBox, row, 1, 1, col);

   }

   // Add controls to dock
   w->setLayout(pLayout);
   setWidget(w);
}
