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
if (NOT _CXX_STDLIB_CHECK_RESULT EQUAL 0)
	message(FATAL_ERROR "Failed to detect the default C++ standard library configuration.")
endif ()
if (NOT _CXX_MACROS MATCHES "#define _LIBCPP_VERSION")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
endif ()

project(Example VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_MODULE_STD 1)
set(CMAKE_CXX_STANDARD 26)
set(CMAKE_CXX_SCAN_FOR_MODULES ON)

macro(add_example_library target_name)
	add_library(Alpha OBJECT)

	set(__modules)
	set(__sources)

	foreach(__file ${ARGN})
		if(__file MATCHES "\.ixx$")
			list(APPEND __modules "${CMAKE_SOURCE_DIR}/modules/example/${target_name}/${__file}")
		else()
			list(APPEND __sources "${CMAKE_CURRENT_SOURCE_DIR}/${__file}")
		endif()
	endforeach()

	# Not sure if the syntax is correct. I want the file set name to begin with
	# an underscore but that is not allowed. Omitting <set> and TYPE (and
	# directly specifying <type> after FILE_SET) works for some reason despite
	# the docs saying otherwise:
	# target_sources(<target>
	# 	[<INTERFACE|PUBLIC|PRIVATE>
	# 	[FILE_SET <set> [TYPE <type>] [BASE_DIRS <dirs>...] [FILES <files>...]]...
	# 	]...)
	target_sources(${target_name}
		PUBLIC
			FILE_SET CXX_MODULES
			BASE_DIRS ${CMAKE_SOURCE_DIR}/modules
			FILES ${__modules}
		PRIVATE
			${__sources}
	)
endmacro()

add_subdirectory(lib)
add_subdirectory(cli)
