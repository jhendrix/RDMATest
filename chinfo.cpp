#include "chinfo.h"

chinfo::chinfo(GPUInfo* pGPUInfo, uint32_t id, uint32_t devIdx, uint32_t bufMB)
{
   void* pMem;
   m_dvcIdx = devIdx;
   m_id = id;
   m_bufMB = bufMB;
   m_GPUInfo = pGPUInfo;
   if(nullptr != m_GPUInfo)
   {
      pMem = m_GPUInfo->AllocMem(bufMB);
   }
}

chinfo::~chinfo()
{

}

