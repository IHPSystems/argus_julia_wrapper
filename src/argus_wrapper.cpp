#include <thread>
#include <Argus/Argus.h>
#include "jlcxx/jlcxx.hpp"
#include "jlcxx/functions.hpp"
#include "uv.h"

JLCXX_MODULE define_argus_wrapper(jlcxx::Module& module)
{
  using namespace Argus;

  module.method("get_argus_version_string", []()
  {
    UniqueObj<CameraProvider> cameraProvider(CameraProvider::create());
    ICameraProvider *iCameraProvider = interface_cast<ICameraProvider>(cameraProvider);
    return iCameraProvider->getVersion();
  });
}
