cmake_minimum_required(VERSION 3.10)

cmake_policy(SET CMP0025 NEW) # Fix for https://docs.binarybuilder.org/stable/troubleshooting/#CMake-complains-%22No-known-for-CXX-compiler%22

project(argus_julia_wrapper)

set(CMAKE_MACOSX_RPATH 1)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")

if(NOT DEFINED CMAKE_PREFIX_PATH AND NOT DEFINED CMAKE_FIND_ROOT_PATH)
  if(DEFINED ENV{CMAKE_PREFIX_PATH})
    set(CMAKE_PREFIX_PATH $ENV{CMAKE_PREFIX_PATH})
  else()
    execute_process(COMMAND bash "-c" "julia --project --eval 'import CxxWrap; if VERSION >= v\"1.3\" println(CxxWrap.prefix_path()) else println(joinpath(dirname(pathof(CxxWrap)), \"..\", \"deps\", \"usr\")) end'" OUTPUT_VARIABLE CMAKE_PREFIX_PATH OUTPUT_STRIP_TRAILING_WHITESPACE)
  endif()
  message(STATUS "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
endif()

find_package(JlCxx)
get_target_property(JlCxx_location JlCxx::cxxwrap_julia LOCATION)
get_filename_component(JlCxx_location ${JlCxx_location} DIRECTORY)
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib;${JlCxx_location}")

message(STATUS "Found JlCxx at ${JlCxx_location}")

add_library(argus_julia_wrapper SHARED argus_wrapper.cpp)

target_link_libraries(argus_julia_wrapper JlCxx::cxxwrap_julia)

if(APPLE)
  message(STATUS "Looking for julia uv library in ${Julia_LIBRARY_DIR}")
  find_library(julia_uv_library NAMES uv PATHS ${Julia_LIBRARY_DIR}/julia)
  message(STATUS "Found julia uv at ${julia_uv_library}")
  add_library(julia_uv SHARED IMPORTED)
  set_property(TARGET julia_uv PROPERTY IMPORTED_LOCATION ${julia_uv_library})

  target_link_libraries(argus_julia_wrapper julia_uv)
endif()

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_MODULE_PATH}")

find_package(Argus REQUIRED)

include_directories(
    ${ARGUS_INCLUDE_DIR}
)

target_link_libraries(${PROJECT_NAME}
    ${ARGUS_LIBRARIES}
)

install(TARGETS
  argus_julia_wrapper
LIBRARY DESTINATION lib
ARCHIVE DESTINATION lib
RUNTIME DESTINATION lib)
