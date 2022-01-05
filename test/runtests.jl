using ArgusWrapper
using Test

@testset "ArgusWrapper" begin
    @show camera_provider = ArgusWrapper.create_camera_provider()
    @show ArgusWrapper.get_argus_version(camera_provider)
    @show ArgusWrapper.get_argus_vendor(camera_provider)
    @show camera_devices = ArgusWrapper.get_camera_devices(camera_provider)
    @show length(camera_devices)
end
