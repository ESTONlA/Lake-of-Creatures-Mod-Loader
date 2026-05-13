
cmake_minimum_required (VERSION 3.8)

add_custom_target(loclm-csharp ALL
	COMMAND dotnet build
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_command(TARGET loclm-csharp POST_BUILD
	COMMAND ${CMAKE_COMMAND} -E remove_directory "${Output_Bin_Dir}/loclm"
	COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/bin/Debug/net10.0 "${Output_Bin_Dir}/loclm"
	COMMAND ${CMAKE_COMMAND} -E remove_directory "${Output_Bin_Dir}/loclm/mods"
	COMMAND ${CMAKE_COMMAND} -E make_directory "${Output_Bin_Dir}/loclm/mods"
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/bin/Debug/net10.0/UndertaleModLib.dll "${CMAKE_SOURCE_DIR}/mod_template/"

)
