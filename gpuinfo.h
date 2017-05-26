#ifndef GPUINFO_H
#define GPUINFO_H

#include <stdint.h>
#include <vector>

using namespace std;


class GPUInfo
{
public:
   GPUInfo();
   uint32_t GetNumGPUs(){return m_nGPUS;}
   std::vector<string> GetGPUProps(uint32_t idx);

private:
   int32_t m_nGPUS = 0;
};

// Creator function
GPUInfo* CreateGPUInfo();


#endif // GPUINFO_H
