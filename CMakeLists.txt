cmake_minimum_required(VERSION 3.31)

set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "0e5b6991-d74f-4b3d-a41c-cf096e0b2508")

# Fedora compiles clang with libstdc++ as the default stdlib
# cmake does not like it when using modules (neither do I: GCC bug 122625)
execute_process(
	COMMAND ${CMAKE_COMMAND} -E echo "#include <iso646.h>"
	COMMAND ${CMAKE_CXX_COMPILER} -E -dM -x c++ -
	OUTPUT_VARIABLE _CXX_MACROS
	RESULT_VARIABLE _CXX_STDLIB_CHECK_RESULT
)
if(NOT _CXX_STDLIB_CHECK_RESULT EQUAL 0)
	message(FATAL_ERROR "Failed to detect the default C++ standard library configuration.")
endif()
if(NOT _CXX_MACROS MATCHES "#define _LIBCPP_VERSION")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
endif()

project(Example VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_MODULE_STD 1)
set(CMAKE_CXX_STANDARD 26)
set(CMAKE_CXX_SCAN_FOR_MODULES ON)

add_subdirectory(lib)
add_subdirectory(cli)
