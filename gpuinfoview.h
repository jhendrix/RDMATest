#ifndef GPUINFOVIEW_H
#define GPUINFOVIEW_H

#include <QObject>
#include <QWidget>
#include "gpuinfo.h"
#include <stdint.h>
#include <QSpinBox>
#include <QDockWidget>
#include <QTextEdit>

class GPUInfoView : public QDockWidget
{
   Q_OBJECT

public:
   GPUInfoView(GPUInfo *pGPU);

private slots:
   void GPUPropUpdate(int gpuIdx);


private:
   void addControls(uint32_t nGPU);

private:
   GPUInfo* m_pGPU = nullptr;
   QSpinBox* m_pGpuSelect = nullptr;
   QTextEdit* m_pMsgBox = nullptr;

};

#endif // GPUINFOVIEW_H
