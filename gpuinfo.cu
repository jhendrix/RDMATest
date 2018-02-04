#include "gpuinfo.h"
#include <cuda_runtime.h>


#define BUF_BYTES 256



GPUInfo* CreateGPUInfo()
{
   return new GPUInfo;
}


GPUInfo::GPUInfo()
{
   cudaError_t error_id = cudaGetDeviceCount(&m_nGPUS);

   if(error_id != cudaSuccess)
   {
      m_nGPUS = 0;
   }
}

std::vector<string> GPUInfo::GetGPUProps(uint32_t idx)
{
   char buf[128];

   // TODO: verify index is in bounds
   vector<string> strlist;

   sprintf_s(buf, "GPU index %d:", idx);
   strlist.push_back(buf);

#if 1
   int32_t deviceCount = 0;
   cudaError_t error_id = cudaGetDeviceCount(&deviceCount);

   if (error_id != cudaSuccess)
   {
      sprintf_s(buf, "cuda error obtaining device count: %s", cudaGetErrorString(error_id));
      strlist.push_back(buf);
      return strlist;
   }

   if((int32_t)idx > deviceCount - 1 )
   {
      sprintf_s(buf, "Invalid index %d.  cuda device count: %d", idx, deviceCount);
      strlist.push_back(buf);
      return strlist;
   }

   int32_t dev = idx;
   int32_t driverVersion = 0, runtimeVersion = 0;

   cudaSetDevice(dev);
   cudaDeviceProp deviceProp;
   cudaGetDeviceProperties(&deviceProp, dev);

   sprintf_s(buf, "\nDevice %d: \"%s\"\n", dev, deviceProp.name);
   strlist.push_back(buf);

   // Console log
   cudaDriverGetVersion(&driverVersion);
   cudaRuntimeGetVersion(&runtimeVersion);
   sprintf_s(buf, "  CUDA Driver Version / Runtime Version          %d.%d / %d.%d\n", driverVersion/1000, (driverVersion%100)/10, runtimeVersion/1000, (runtimeVersion%100)/10);
   strlist.push_back(buf);
   sprintf_s(buf, "  CUDA Capability Major/Minor version number:    %d.%d\n", deviceProp.major, deviceProp.minor);
   strlist.push_back(buf);

   sprintf_s(buf, "  Total amount of global memory:                 %.0f MBytes (%llu bytes)\n",
          (float)deviceProp.totalGlobalMem/1048576.0f, (unsigned long long) deviceProp.totalGlobalMem);
   strlist.push_back(buf);

//   sprintf_s(buf, "  (%2d) Multiprocessors, (%3d) CUDA Cores/MP:     %d CUDA Cores\n",
//         deviceProp.multiProcessorCount,
//         _ConvertSMVer2Cores(deviceProp.major, deviceProp.minor),
//         _ConvertSMVer2Cores(deviceProp.major, deviceProp.minor) * deviceProp.multiProcessorCount);
//   strlist.push_back(buf);
   sprintf_s(buf, "  GPU Max Clock rate:                            %.0f MHz (%0.2f GHz)\n", deviceProp.clockRate * 1e-3f, deviceProp.clockRate * 1e-6f);
   strlist.push_back(buf);


#if CUDART_VERSION >= 5000
   // This is supported in CUDA 5.0 (runtime API device properties)
   sprintf_s(buf, "  Memory Clock rate:                             %.0f Mhz\n", deviceProp.memoryClockRate * 1e-3f);
   strlist.push_back(buf);
   sprintf_s(buf, "  Memory Bus Width:                              %d-bit\n",   deviceProp.memoryBusWidth);
   strlist.push_back(buf);

   if (deviceProp.l2CacheSize)
   {
      sprintf_s(buf, "  L2 Cache Size:                                 %d bytes\n", deviceProp.l2CacheSize);
      strlist.push_back(buf);
   }

#else
   // This only available in CUDA 4.0-4.2 (but these were only exposed in the CUDA Driver API)
   int memoryClock;
   getCudaAttribute<int>(&memoryClock, CU_DEVICE_ATTRIBUTE_MEMORY_CLOCK_RATE, dev);
   sprintf_s(buf, "  Memory Clock rate:                             %.0f Mhz\n", memoryClock * 1e-3f);
   strlist.push_back(buf);
   int memBusWidth;
   getCudaAttribute<int>(&memBusWidth, CU_DEVICE_ATTRIBUTE_GLOBAL_MEMORY_BUS_WIDTH, dev);
   sprintf_s(buf, "  Memory Bus Width:                              %d-bit\n", memBusWidth);
   strlist.push_back(buf);
   int L2CacheSize;
   getCudaAttribute<int>(&L2CacheSize, CU_DEVICE_ATTRIBUTE_L2_CACHE_SIZE, dev);

   if (L2CacheSize)
   {
      sprintf_s(buf, "  L2 Cache Size:                                 %d bytes\n", L2CacheSize);
      strlist.push_back(buf);
   }

#endif

   sprintf_s(buf, "  Maximum Texture Dimension Size (x,y,z)         1D=(%d), 2D=(%d, %d), 3D=(%d, %d, %d)\n",
         deviceProp.maxTexture1D   , deviceProp.maxTexture2D[0], deviceProp.maxTexture2D[1],
         deviceProp.maxTexture3D[0], deviceProp.maxTexture3D[1], deviceProp.maxTexture3D[2]);
   strlist.push_back(buf);
   sprintf_s(buf, "  Maximum Layered 1D Texture Size, (num) layers  1D=(%d), %d layers\n",
         deviceProp.maxTexture1DLayered[0], deviceProp.maxTexture1DLayered[1]);
   strlist.push_back(buf);
   sprintf_s(buf, "  Maximum Layered 2D Texture Size, (num) layers  2D=(%d, %d), %d layers\n",
         deviceProp.maxTexture2DLayered[0], deviceProp.maxTexture2DLayered[1], deviceProp.maxTexture2DLayered[2]);
   strlist.push_back(buf);


   sprintf_s(buf, "  Total amount of constant memory:               %lu bytes\n", deviceProp.totalConstMem);
   strlist.push_back(buf);
   sprintf_s(buf, "  Total amount of shared memory per block:       %lu bytes\n", deviceProp.sharedMemPerBlock);
   strlist.push_back(buf);
   sprintf_s(buf, "  Total number of registers available per block: %d\n", deviceProp.regsPerBlock);
   strlist.push_back(buf);
   sprintf_s(buf, "  Warp size:                                     %d\n", deviceProp.warpSize);
   strlist.push_back(buf);
   sprintf_s(buf, "  Maximum number of threads per multiprocessor:  %d\n", deviceProp.maxThreadsPerMultiProcessor);
   strlist.push_back(buf);
   sprintf_s(buf, "  Maximum number of threads per block:           %d\n", deviceProp.maxThreadsPerBlock);
   strlist.push_back(buf);
   sprintf_s(buf, "  Max dimension size of a thread block (x,y,z): (%d, %d, %d)\n",
         deviceProp.maxThreadsDim[0],
         deviceProp.maxThreadsDim[1],
         deviceProp.maxThreadsDim[2]);
   strlist.push_back(buf);
   sprintf_s(buf, "  Max dimension size of a grid size    (x,y,z): (%d, %d, %d)\n",
         deviceProp.maxGridSize[0],
         deviceProp.maxGridSize[1],
         deviceProp.maxGridSize[2]);
   strlist.push_back(buf);
   sprintf_s(buf, "  Maximum memory pitch:                          %lu bytes\n", deviceProp.memPitch);
   strlist.push_back(buf);
   sprintf_s(buf, "  Texture alignment:                             %lu bytes\n", deviceProp.textureAlignment);
   strlist.push_back(buf);
   sprintf_s(buf, "  Concurrent copy and kernel execution:          %s with %d copy engine(s)\n", (deviceProp.deviceOverlap ? "Yes" : "No"), deviceProp.asyncEngineCount);
   strlist.push_back(buf);
   sprintf_s(buf, "  Run time limit on kernels:                     %s\n", deviceProp.kernelExecTimeoutEnabled ? "Yes" : "No");
   strlist.push_back(buf);
   sprintf_s(buf, "  Integrated GPU sharing Host Memory:            %s\n", deviceProp.integrated ? "Yes" : "No");
   strlist.push_back(buf);
   sprintf_s(buf, "  Support host page-locked memory mapping:       %s\n", deviceProp.canMapHostMemory ? "Yes" : "No");
   strlist.push_back(buf);
   sprintf_s(buf, "  Alignment requirement for Surfaces:            %s\n", deviceProp.surfaceAlignment ? "Yes" : "No");
   strlist.push_back(buf);
   sprintf_s(buf, "  Device has ECC support:                        %s\n", deviceProp.ECCEnabled ? "Enabled" : "Disabled");
   strlist.push_back(buf);
#if defined(WIN32) || defined(_WIN32) || defined(WIN64) || defined(_WIN64)
   sprintf_s(buf, "  CUDA Device Driver Mode (TCC or WDDM):         %s\n", deviceProp.tccDriver ? "TCC (Tesla Compute Cluster Driver)" : "WDDM (Windows Display Driver Model)");
   strlist.push_back(buf);
#endif
   sprintf_s(buf, "  Device supports Unified Addressing (UVA):      %s\n", deviceProp.unifiedAddressing ? "Yes" : "No");
   strlist.push_back(buf);
   sprintf_s(buf, "  Device PCI Domain ID / Bus ID / location ID:   %d / %d / %d\n", deviceProp.pciDomainID, deviceProp.pciBusID, deviceProp.pciDeviceID);
   strlist.push_back(buf);

   const char *sComputeMode[] =
   {
      "Default (multiple host threads can use ::cudaSetDevice() with device simultaneously)",
      "Exclusive (only one host thread in one process is able to use ::cudaSetDevice() with this device)",
      "Prohibited (no host thread can use ::cudaSetDevice() with this device)",
      "Exclusive Process (many threads in one process is able to use ::cudaSetDevice() with this device)",
      "Unknown",
      NULL
   };
   sprintf_s(buf, "  Compute Mode:\n");
   strlist.push_back(buf);
   if( 6 > deviceProp.computeMode)
   {
      sprintf_s(buf, "     < %s >\n", sComputeMode[deviceProp.computeMode]);
      strlist.push_back(buf);
   }
   else
   {
      sprintf_s(buf, "     Unexpected computeMode %d\n",deviceProp.computeMode);
      strlist.push_back(buf);
   }

    // If there are 2 or more GP
   //cudaDeviceProp prop[64];
   //checkCudaErrors(cudaGetDeviceProperties(&prop[dev], dev));

      // Only boards based on Fermi or later can support P2P
   if ((deviceProp.major >= 2)
 #if defined(WIN32) || defined(_WIN32) || defined(WIN64) || defined(_WIN64)
          // on Windows (64-bit), the Tesla Compute Cluster driver for windows must be enabled to support this
          && deviceProp.tccDriver
#endif
         )
      {
          // This is an array of P2P capable GPUs
         strlist.push_back("Peer to peer access capable!");
      }


    // csv masterlog info
    // *****************************
    // exe and CUDA driver name
    sprintf_s(buf, "\n");
    std::string sProfileString = "deviceQuery, CUDA Driver = CUDART";
    char cTemp[16];

    // driver version
    sProfileString += ", CUDA Driver Version = ";
#if defined(WIN32) || defined(_WIN32) || defined(WIN64) || defined(_WIN64)
    sprintf_s(cTemp, "%d.%d", driverVersion/1000, (driverVersion%100)/10);
#else
    sprintf_s(cTemp, "%d.%d", driverVersion/1000, (driverVersion%100)/10);
#endif
    sProfileString +=  cTemp;

    // Runtime version
    sProfileString += ", CUDA Runtime Version = ";
#if defined(WIN32) || defined(_WIN32) || defined(WIN64) || defined(_WIN64)
    sprintf_s(cTemp, "%d.%d", runtimeVersion/1000, (runtimeVersion%100)/10);
#else
    ssprintf_s(buf, cTemp, "%d.%d", runtimeVersion/1000, (runtimeVersion%100)/10);
#endif
    sProfileString +=  cTemp;

    // Device count
    sProfileString += ", NumDevs = ";
#if defined(WIN32) || defined(_WIN32) || defined(WIN64) || defined(_WIN64)
    sprintf_s(cTemp, "%d", deviceCount);
#else
    ssprintf_s(buf, cTemp, "%d", deviceCount);
#endif
    sProfileString += cTemp;


    sProfileString += "\n";
    strlist.push_back(sProfileString);
#endif

    return strlist;
}

void* GPUInfo::AllocMem(uint32_t nMB)
{
   cudaError_t ret = cudaMalloc(&m_dvcBufPtr, nMB * 0x00100000);

   if(cudaSuccess != ret)
   {
      m_dvcBufPtr = nullptr;
   }

   return m_dvcBufPtr;

}
