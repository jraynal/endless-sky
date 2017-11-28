# - Try to find libmad
# Once done, this will define
#
#  MAD_FOUND - system has libmad
#  MAD_INCLUDE_DIRS - the libmad include directories
#  MAD_LIBRARIES - link these to use libmad
#
# this file is modelled after http://www.cmake.org/Wiki/CMake:How_To_Find_Libraries

include(FindPkgConfig)

# Use pkg-config to get hints about paths
pkg_check_modules(MAD_PKGCONF QUIET mad)

# Include dir
find_path(MAD_INCLUDE_DIR
  NAMES mad.h
  PATHS ${MAD_PKGCONF_INCLUDE_DIRS} $ENV{MAD_ROOT}/include
)

# Finally the library itself
find_library(MAD_LIBRARY
  NAMES libmad.so libmad.0.so libmad.lib libmad.dylib libmad.a
  PATHS ${MAD_PKGCONF_LIBRARY_DIRS} $ENV{MAD_ROOT}/lib
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MAD FOUND_VAR MAD_FOUND
                                  REQUIRED_VARS MAD_LIBRARY MAD_INCLUDE_DIR)

if(MAD_FOUND)
  set(MAD_INCLUDE_DIRS ${MAD_INCLUDE_DIR})
  set(MAD_LIBRARIES ${MAD_LIBRARY})

  if (NOT TARGET MAD::MAD)
    add_library(MAD::MAD UNKNOWN IMPORTED)
    set_target_properties(MAD::MAD
                          PROPERTIES IMPORTED_LOCATION "${MAD_LIBRARY}"
                                     INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${MAD_INCLUDE_DIR}")
  endif()
else()
  unset(MAD_INCLUDE_DIR)
  unset(MAD_INCLUDE_DIRS)
  unset(MAD_LIBRARY)
  unset(MAD_LIBRARIES)
endif()
