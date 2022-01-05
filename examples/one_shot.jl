using ArgusWrapper

camera_provider = ArgusWrapper.create_camera_provider()
argus_version = ArgusWrapper.get_argus_version(camera_provider)
println("Argus version: $(argus_version)")
camera_devices = ArgusWrapper.get_camera_devices(camera_provider)
if isempty(camera_devices)
    println("No cameras available!")
    exit(1)
end
camera_device = first(camera_devices)
@show camera_device
sensor_modes = ArgusWrapper.get_all_sensor_modes(camera_device)
for sensor_mode in sensor_modes
    @show Int.(ArgusWrapper.get_resolution(sensor_mode))
end
