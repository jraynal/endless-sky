cmake_minimum_required(VERSION 3.1.0)
project(endless-sky CXX)

set(CMAKE_CXX_STANDARD 11)

find_package(SDL2 REQUIRED)
# Fix for CMP0004 failure when SDL2_LIBRARIES ends with spaces
string(STRIP "${SDL2_LIBRARIES}" SDL2_LIBRARIES)
find_package(PNG REQUIRED)
find_package(JPEG REQUIRED)
find_package(GLEW REQUIRED)
find_package(OpenAL REQUIRED)

find_package(PkgConfig REQUIRED)
pkg_search_module(libmad REQUIRED mad)

file(GLOB SOURCES source/*.cpp source/*.h)


add_executable(endless-sky ${SOURCES})
target_link_libraries(endless-sky ${SDL2_LIBRARIES} ${PNG_LIBRARY} ${JPEG_LIBRARY} ${GLEW_LIBRARY} ${OPENAL_LIBRARY} ${libmad_LIBRARIES})

install(TARGETS endless-sky RUNTIME DESTINATION games)
install(DIRECTORY data images sounds DESTINATION share/games/endless-sky)
install(FILES credits.txt keys.txt DESTINATION share/games/endless-sky)
install(FILES endless-sky.desktop DESTINATION share/applications)
install(FILES endless-sky.appdata.xml DESTINATION share/appdata)

foreach(SIZE 16x16 22x22 24x24 32x32 48x48 256x256)
    install(FILES endless-sky.iconset/icon_${SIZE}.png RENAME endless-sky.png DESTINATION share/icons/hicolor/${SIZE}/apps)
endforeach()
