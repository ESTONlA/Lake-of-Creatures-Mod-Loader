# CMakeList.txt : Top-level CMake project file, do global configuration
# and include sub-projects here.
#

cmake_minimum_required (VERSION 3.27)

project ("loclm")
include(FetchContent)

option(LOCLM_ENABLE_STEAMWORKS "Enable Steam relay multiplayer bridge" OFF)
set(STEAMWORKS_SDK_DIR "" CACHE PATH "Path to the Steamworks SDK root")

FetchContent_Declare(
    undertalemodtool
    GIT_REPOSITORY https://github.com/krzys-h/UndertaleModTool.git
    GIT_TAG 92387986e4ee99974406bedb7d061d42871e944f
    GIT_SUBMODULES_RECURSE TRUE
)

FetchContent_MakeAvailable(undertalemodtool)

file(COPY ${undertalemodtool_SOURCE_DIR} DESTINATION ${CMAKE_SOURCE_DIR})

set(Output_Bin_Dir "${CMAKE_SOURCE_DIR}/out/bin/")


# Include sub-projects.
add_subdirectory ("loclm-cxx")

add_subdirectory("loclm-csharp")
