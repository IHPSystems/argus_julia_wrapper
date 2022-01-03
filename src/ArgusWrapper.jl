module ArgusWrapper

using CxxWrap
@wrapmodule(joinpath(@__DIR__, "..", "build", "lib", "libargus_julia_wrapper"), :define_argus_wrapper)

function __init__()
    @initcxx
end

end # module
