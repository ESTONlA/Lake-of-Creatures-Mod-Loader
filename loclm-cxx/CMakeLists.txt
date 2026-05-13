# CMakeList.txt : CMake project for loclm-cxx, include source and define
# project specific logic here.
#
cmake_minimum_required (VERSION 3.8)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set( CMAKE_VERBOSE_MAKEFILE on )
add_definitions(-DUNICODE)
message("${CMAKE_CURRENT_SOURCE_DIR}")

add_library(loclm-cxx SHARED "src/dllmain.cpp" "res/version.def")

target_include_directories(loclm-cxx PRIVATE "include/")

set_target_properties(loclm-cxx PROPERTIES OUTPUT_NAME "version")

add_custom_command(TARGET loclm-cxx POST_BUILD
	COMMAND ${CMAKE_COMMAND} -E make_directory ${Output_Bin_Dir}
    COMMAND ${CMAKE_COMMAND} -E make_directory "${Output_Bin_Dir}/loclm/mods"
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:loclm-cxx> "${Output_Bin_Dir}/version.dll"
)
