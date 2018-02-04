#include "mainwindow.h"
#include "chview.h"
#include "gpuinfo.h"
#include "gpuinfoview.h"

#define NCH 4

MainWindow::MainWindow(QWidget *parent)
   : QMainWindow(parent)
{
   ChView* pDock;

   GPUInfo *pGPUInfo = CreateGPUInfo();

   for(auto i = 0; i < NCH; ++i)
   {
      pDock = new ChView(QString("CH %1").arg(i + 1), new chinfo(pGPUInfo, i, 0, 4));
      pDock->setAllowedAreas(Qt::AllDockWidgetAreas);
      addDockWidget(Qt::TopDockWidgetArea, pDock);
   }

   GPUInfoView* pGPUInfoDock = new GPUInfoView(pGPUInfo);
   addDockWidget(Qt::RightDockWidgetArea, pGPUInfoDock);

}

MainWindow::~MainWindow()
{

}
