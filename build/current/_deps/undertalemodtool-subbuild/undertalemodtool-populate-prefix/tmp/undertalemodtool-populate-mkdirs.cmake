# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENSE.rst or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION ${CMAKE_VERSION}) # this file comes with cmake

# If CMAKE_DISABLE_SOURCE_CHANGES is set to true and the source directory is an
# existing directory in our source tree, calling file(MAKE_DIRECTORY) on it
# would cause a fatal error, even though it would be a no-op.
if(NOT EXISTS "C:/Users/ksuti/Desktop/Lake-of-Creatures-Mod-Loader/build/current/_deps/undertalemodtool-src")
  file(MAKE_DIRECTORY "C:/Users/ksuti/Desktop/Lake-of-Creatures-Mod-Loader/build/current/_deps/undertalemodtool-src")
endif()
file(MAKE_DIRECTORY
  "C:/Users/ksuti/Desktop/Lake-of-Creatures-Mod-Loader/build/current/_deps/undertalemodtool-build"
  "C:/Users/ksuti/Desktop/Lake-of-Creatures-Mod-Loader/build/current/_deps/undertalemodtool-subbuild/undertalemodtool-populate-prefix"
  "C:/Users/ksuti/Desktop/Lake-of-Creatures-Mod-Loader/build/current/_deps/undertalemodtool-subbuild/undertalemodtool-populate-prefix/tmp"
  "C:/Users/ksuti/Desktop/Lake-of-Creatures-Mod-Loader/build/current/_deps/undertalemodtool-subbuild/undertalemodtool-populate-prefix/src/undertalemodtool-populate-stamp"
  "C:/Users/ksuti/Desktop/Lake-of-Creatures-Mod-Loader/build/current/_deps/undertalemodtool-subbuild/undertalemodtool-populate-prefix/src"
  "C:/Users/ksuti/Desktop/Lake-of-Creatures-Mod-Loader/build/current/_deps/undertalemodtool-subbuild/undertalemodtool-populate-prefix/src/undertalemodtool-populate-stamp"
)

set(configSubDirs Debug)
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "C:/Users/ksuti/Desktop/Lake-of-Creatures-Mod-Loader/build/current/_deps/undertalemodtool-subbuild/undertalemodtool-populate-prefix/src/undertalemodtool-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "C:/Users/ksuti/Desktop/Lake-of-Creatures-Mod-Loader/build/current/_deps/undertalemodtool-subbuild/undertalemodtool-populate-prefix/src/undertalemodtool-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
