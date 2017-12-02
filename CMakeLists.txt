cmake_minimum_required(VERSION 3.0.2)
project(endless-sky CXX)
set(EXEC_NAME "${PROJECT_NAME}")

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Find required dependencies
foreach(req_lib SDL2 PNG OpenGL GLEW OpenAL JpegTurbo MAD)
	find_package(${req_lib} REQUIRED)
endforeach()

# Load all the source files
file(GLOB SOURCES source/*.cpp)
file(GLOB HEADERS source/*.h)

if(APPLE)
	set(BUNDLE MACOSX_BUNDLE)
endif()

# Create the target
add_executable(${EXEC_NAME} ${BUNDLE} ${SOURCES} ${HEADERS}
                                      ${RES_FILES})

set(ICON_FILE icon.png)
set_source_files_properties(${ICON_FILE} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
set(MACOSX_BUNDLE_BUNDLE_NAME EndlessSky)
set(MACOSX_BUNDLE_ICON_FILE ${ICON_FILE})

set(RES_FILES credits.txt keys.txt ${ICON_FILE})
set(RES_DIRS data images sounds)
source_group(Resources FILES ${RES_FILES})
target_sources(${EXEC_NAME} PUBLIC ${RES_FILES})

# Try to maintain directory structure in MacOSX apps
if(APPLE)
foreach(resdir ${RES_DIRS})
	file(GLOB_RECURSE RES_SOURCES "${resdir}/*")
	foreach(resfile ${RES_SOURCES})
		# Cut absolute paths down
		string(REPLACE "${CMAKE_SOURCE_DIR}/" "" resfiledir ${resfile})
		get_filename_component(resfiledir ${resfiledir} DIRECTORY)
		# Add the resources to sources, group them (for XCode mostly), and make sure they are installed correctly
		target_sources(${EXEC_NAME} PUBLIC ${resfile})
		source_group(Resources\\${resdir} FILES ${resfile})
		set_source_files_properties("${resfile}" PROPERTIES MACOSX_PACKAGE_LOCATION Resources/${resfiledir})
	endforeach()
endforeach()
endif()

target_link_libraries(${EXEC_NAME} PRIVATE
                      ${PNG_LIBRARY}
                      JpegTurbo::JpegTurbo
                      GLEW::GLEW
                      OpenGL::GLU
                      MAD::MAD
                      ${OPENAL_LIBRARY}
                      ${SDL2_LIBRARIES})

# Necessary to load jpeg-turbo includes before the system ones :(
target_include_directories(${EXEC_NAME} SYSTEM PRIVATE ${JpegTurbo_INCLUDE_DIRS})

# Installation
if (APPLE)
	# Mac .app are relocalizable
	set_target_properties(${EXEC_NAME} PROPERTIES
	                      MAC_OSX_BUNDLE TRUE
	                      MACOSX_FRAMEWORK_IDENTIFIER com.game.EndlessSky
	                      RESOURCE "${RES_FILES};${ICON_FILE}"
	)
else()
	install(DIRECTORY ${RES_DIRS} DESTINATION share/games/${EXEC_NAME})
	install(FILES ${RES_FILES} DESTINATION share/games/${EXEC_NAME})

	# Linux specifics
	install(FILES ${EXEC_NAME}.desktop DESTINATION share/applications)
	install(FILES ${EXEC_NAME}.appdata.xml DESTINATION share/appdata)
	install(TARGETS ${EXEC_NAME} RUNTIME DESTINATION games)
endif()


#foreach(SIZE 16x16 22x22 24x24 32x32 48x48 256x256)
#    install(FILES ${EXEC_NAME}.iconset/icon_${SIZE}.png RENAME ${EXEC_NAME}.png DESTINATION share/icons/hicolor/${SIZE}/apps)
#endforeach()
