# - Try to find libjpeg-turbo
# Once done, this will define
#
#  JpegTurbo_FOUND - system has libjpeg-turbo
#  JpegTurbo_INCLUDE_DIRS - the libjpeg-turbo include directories
#  JpegTurbo_LIBRARIES - link these to use libjpeg-turbo
#  JpegTurbo_VERSION - the version of libjpeg-turbo
#
# this file is modelled after http://www.cmake.org/Wiki/CMake:How_To_Find_Libraries

include(FindPkgConfig)

# Use pkg-config to get hints about paths
pkg_check_modules(JpegTurbo_PKGCONF QUIET JpegTurbo)

# Include dir
find_path(JpegTurbo_INCLUDE_DIR
  NAMES turbojpeg.h
  PATHS ${JpegTurbo_PKGCONF_INCLUDE_DIRS} /opt/libjpeg-turbo/include /usr/local/opt/libjpeg-turbo/include $ENV{JpegTurbo_ROOT}/include
)

# Search for header with version: jconfig.h
if(JpegTurbo_INCLUDE_DIR)
  if(EXISTS "${JpegTurbo_INCLUDE_DIR}/jconfig-64.h")
    set(_version_header "${JpegTurbo_INCLUDE_DIR}/jconfig-64.h")
  elseif(EXISTS "${JpegTurbo_INCLUDE_DIR}/jconfig.h")
    set(_version_header "${JpegTurbo_INCLUDE_DIR}/jconfig.h")
  elseif(EXISTS "${JpegTurbo_INCLUDE_DIR}/x86_64-linux-gnu/jconfig.h")
    set(_version_header "${JpegTurbo_INCLUDE_DIR}/x86_64-linux-gnu/jconfig.h")
  else()
    set(_version_header)
    if(NOT JpegTurbo_FIND_QUIETLY)
      message(STATUS "Could not find 'jconfig.h' to check version")
    endif()
  endif()
endif()

# Found the header, read version
if(_version_header)
  file(READ "${_version_header}" _header)
  if(_header)
   string(REGEX REPLACE ".*#define[\t ]+LIBJPEG_TURBO_VERSION[\t ]+([0-9.]+).*"
     "\\1" JpegTurbo_VERSION "${_header}")
  endif()
  unset(_header)
endif()

# Finally the library itself
find_library(JpegTurbo_LIBRARY
  NAMES libturbojpeg.so libturbojpeg.so.0 turbojpeg.lib libturbojpeg.dylib
  PATHS ${JpegTurbo_PKGCONF_LIBRARY_DIRS} /opt/libjpeg-turbo/lib /usr/local/opt/libjpeg-turbo/lib $ENV{JpegTurbo_ROOT}/lib
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(JpegTurbo FOUND_VAR JpegTurbo_FOUND
                                  REQUIRED_VARS JpegTurbo_LIBRARY
                                  JpegTurbo_INCLUDE_DIR JpegTurbo_VERSION
                                  VERSION_VAR JpegTurbo_VERSION)

if(JpegTurbo_FOUND)
  set(JpegTurbo_INCLUDE_DIRS ${JpegTurbo_INCLUDE_DIR})
  set(JpegTurbo_LIBRARIES jpegturbo)

  add_library(${JpegTurbo_LIBRARIES} SHARED IMPORTED)
  set_target_properties(${JpegTurbo_LIBRARIES}
                        PROPERTIES IMPORTED_LOCATION ${JpegTurbo_LIBRARY}
                                   INTERFACE_INCLUDE_DIRECTORIES ${JpegTurbo_INCLUDE_DIR})


  if(NOT JpegTurbo_FIND_QUIETLY)
    get_filename_component(_dir ${JpegTurbo_INCLUDE_DIR} DIRECTORY)
    message(STATUS "Found JpegTurbo [version: ${JpegTurbo_VERSION}]: ${_dir}")
  endif()
else()
  set(JpegTurbo_INCLUDE_DIR)
  set(JpegTurbo_INCLUDE_DIRS)
  set(JpegTurbo_LIBRARY)
  set(JpegTurbo_LIBRARIES)
  set(JpegTurbo_VERSION)
endif()
