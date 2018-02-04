#ifndef CHINFO_H
#define CHINFO_H

#include <QObject>
#include <stdint.h>
#include "gpuinfo.h"

class chinfo
{
public:
   chinfo(GPUInfo *pGPUInfo, uint32_t id, uint32_t devIdx, uint32_t bufMB);
   ~chinfo();

private:
   uint32_t  m_bufMB = 0;
   uint32_t  m_id = 0;
   uint32_t m_dvcIdx = 0;
   GPUInfo* m_GPUInfo;
};

#endif // CHINFO_H
