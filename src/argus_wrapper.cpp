#include <thread>
#include <Argus/Argus.h>
#include "jlcxx/jlcxx.hpp"
#include "jlcxx/functions.hpp"
#include "uv.h"

JLCXX_MODULE define_argus_wrapper(jlcxx::Module& module)
{
  using namespace Argus;

  module.method("create_camera_provider", []()
  {
    return (void*) CameraProvider::create();
  });
  module.method("get_argus_version", [](void* cameraProviderPtr)
  {
    auto iCameraProvider = interface_cast<ICameraProvider>((CameraProvider*) cameraProviderPtr);
    return iCameraProvider->getVersion();
  });
  module.method("get_argus_vendor", [](void* cameraProviderPtr)
  {
    auto iCameraProvider = interface_cast<ICameraProvider>((CameraProvider*) cameraProviderPtr);
    return iCameraProvider->getVendor();
  });
  module.method("get_camera_devices", [](void* cameraProviderPtr)
  {
    auto iCameraProvider = interface_cast<ICameraProvider>((CameraProvider*) cameraProviderPtr);
    std::vector<CameraDevice*> cameraDevices;
    auto status = iCameraProvider->getCameraDevices(&cameraDevices);
    auto cameraDevicePtrs = new std::vector<void*>();
    cameraDevicePtrs->assign(cameraDevices.begin(), cameraDevices.end());
    return cameraDevicePtrs;
  });
}
