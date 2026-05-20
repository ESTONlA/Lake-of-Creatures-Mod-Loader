# CMakeList.txt : CMake project for loclm-cxx, include source and define
# project specific logic here.
#
cmake_minimum_required (VERSION 3.8)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set( CMAKE_VERBOSE_MAKEFILE on )
add_definitions(-DUNICODE)
message("${CMAKE_CURRENT_SOURCE_DIR}")

set(LOCLM_CXX_SOURCES
	"src/dllmain.cpp"
	"steam/SteamBridge.cpp"
	"steam/SteamLobby.cpp"
	"steam/SteamP2P.cpp"
	"steam/LocalBridgeServer.cpp"
	"steam/MpPackets.cpp"
	"res/version.def")

add_library(loclm-cxx SHARED ${LOCLM_CXX_SOURCES})

target_include_directories(loclm-cxx PRIVATE "include/" "steam/")
target_link_libraries(loclm-cxx PRIVATE Ws2_32)

if(LOCLM_ENABLE_STEAMWORKS)
	if(NOT STEAMWORKS_SDK_DIR)
		message(FATAL_ERROR "LOCLM_ENABLE_STEAMWORKS is ON but STEAMWORKS_SDK_DIR is not set")
	endif()

	set(STEAMWORKS_PUBLIC_DIR "${STEAMWORKS_SDK_DIR}/public")
	set(STEAMWORKS_REDIST_DIR "${STEAMWORKS_SDK_DIR}/redistributable_bin/win64")
	set(STEAMWORKS_LIB "${STEAMWORKS_REDIST_DIR}/steam_api64.lib")
	set(STEAMWORKS_DLL "${STEAMWORKS_REDIST_DIR}/steam_api64.dll")

	if(NOT EXISTS "${STEAMWORKS_PUBLIC_DIR}")
		message(FATAL_ERROR "Steamworks public include directory not found: ${STEAMWORKS_PUBLIC_DIR}")
	endif()
	if(NOT EXISTS "${STEAMWORKS_LIB}")
		message(FATAL_ERROR "steam_api64.lib not found: ${STEAMWORKS_LIB}")
	endif()
	if(NOT EXISTS "${STEAMWORKS_DLL}")
		message(FATAL_ERROR "steam_api64.dll not found: ${STEAMWORKS_DLL}")
	endif()

	target_include_directories(loclm-cxx PRIVATE "${STEAMWORKS_PUBLIC_DIR}")
	target_link_libraries(loclm-cxx PRIVATE "${STEAMWORKS_LIB}")
	target_compile_definitions(loclm-cxx PRIVATE LOCLM_ENABLE_STEAMWORKS=1)
else()
	target_compile_definitions(loclm-cxx PRIVATE LOCLM_ENABLE_STEAMWORKS=0)
endif()

set_target_properties(loclm-cxx PROPERTIES
	OUTPUT_NAME "version"
	MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>"
)

add_custom_command(TARGET loclm-cxx POST_BUILD
	COMMAND ${CMAKE_COMMAND} -E make_directory ${Output_Bin_Dir}
    COMMAND ${CMAKE_COMMAND} -E make_directory "${Output_Bin_Dir}/loclm/mods"
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:loclm-cxx> "${Output_Bin_Dir}/version.dll"
)

if(LOCLM_ENABLE_STEAMWORKS)
	add_custom_command(TARGET loclm-cxx POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E copy_if_different "${STEAMWORKS_DLL}" "${Output_Bin_Dir}/steam_api64.dll"
	)
endif()
