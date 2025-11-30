cmake_minimum_required(VERSION 3.31)

# This varies with cmake version.
# See https://github.com/Kitware/CMake/blob/v${cmake_version}/Help/dev/experimental.rst
set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "0e5b6991-d74f-4b3d-a41c-cf096e0b2508")

# Fedora compiles clang with libstdc++ as the default stdlib. CMake wants libc++.
# Also, std.cc is broken in gcc 15.2.1: See GCC bug 122625.
execute_process(
    COMMAND echo "#include <ciso646>"
    COMMAND ${CMAKE_CXX_COMPILER} -E -dM -x c++ -
    OUTPUT_VARIABLE _CXX_MACROS
    RESULT_VARIABLE _CXX_STDLIB_RESULT
)
if (NOT _CXX_STDLIB_RESULT EQUAL 0)
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
    add_library(${target_name} OBJECT)

    set(__scope PUBLIC)
    set(__pub_modules)
    set(__priv_modules)
    set(__pub_sources)
    set(__priv_sources)

    foreach (__arg ${ARGN})
        if (__arg STREQUAL "PUBLIC")
            set(__scope PUBLIC)
        elseif (__arg STREQUAL "PRIVATE")
            set(__scope PRIVATE)
        elseif (__arg MATCHES "\.ixx$")
            if (__scope STREQUAL "PUBLIC")
                list(APPEND __pub_modules "${CMAKE_SOURCE_DIR}/modules/example/${__arg}")
            else ()
                list(APPEND __priv_modules "${__arg}")
            endif ()
        else ()
            if (__scope STREQUAL "PUBLIC")
                list(APPEND __pub_sources "${__arg}")
            else ()
                list(APPEND __priv_sources "${__arg}")
            endif ()
        endif ()
    endforeach ()

    target_sources(${target_name}
        PUBLIC
            ${__pub_sources}
        PUBLIC
            FILE_SET modules_${target_name}_
            TYPE CXX_MODULES
            BASE_DIRS ${CMAKE_SOURCE_DIR}/modules/example
            FILES ${__pub_modules}
        PRIVATE
            ${__priv_sources}
        PRIVATE
            FILE_SET priv_modules_${target_name}_
            TYPE CXX_MODULES
            BASE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}
            FILES ${__priv_modules}
    )
endmacro()

add_subdirectory(lib)
add_subdirectory(cli)
