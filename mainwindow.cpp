#include "mainwindow.h"
#include "chview.h"
#include "gpuinfo.h"
#include "gpuinfoview.h"

#define NCH 4

MainWindow::MainWindow(QWidget *parent)
   : QMainWindow(parent)
{
   ChView* pDock;

   for(auto i = 0; i < NCH; ++i)
   {
      pDock = new ChView(QString("CH %1").arg(i + 1));
      pDock->setAllowedAreas(Qt::AllDockWidgetAreas);
      addDockWidget(Qt::TopDockWidgetArea, pDock);
   }

   GPUInfo *pGPUInfo = CreateGPUInfo();
   GPUInfoView* pGPUInfoDock = new GPUInfoView(pGPUInfo);
   addDockWidget(Qt::RightDockWidgetArea, pGPUInfoDock);

}

MainWindow::~MainWindow()
{

}
