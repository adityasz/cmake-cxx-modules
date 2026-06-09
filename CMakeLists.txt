cmake_minimum_required(VERSION 4.3)

project(example VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_MODULE_STD 1)
set(CMAKE_CXX_STANDARD 26)
set(CMAKE_CXX_SCAN_FOR_MODULES ON)

function(add_example_library target_name)
    cmake_parse_arguments(ARG
        ""
        ""
        "MODULES;LINK_LIBS"
        ${ARGN}
    )

    set(srcs)
    set(private_modules)
    foreach (arg ${ARG_UNPARSED_ARGUMENTS})
        if (arg MATCHES "\.ixx$")
            list(APPEND private_modules ${arg})
        else ()
            list(APPEND srcs ${arg})
        endif ()
    endforeach ()

    add_library(${target_name} OBJECT ${srcs})
    if (private_modules)
        target_sources(${target_name}
            PRIVATE
                FILE_SET private_modules_${target_name}
                TYPE CXX_MODULES
                BASE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}
                FILES ${private_modules}
        )
    endif ()

    if (ARG_MODULES)
        set(module_dir "${CMAKE_SOURCE_DIR}/modules/example/${target_name}/")
        list(TRANSFORM ARG_MODULES PREPEND ${module_dir}
             OUTPUT_VARIABLE module_files)
        target_sources(${target_name}
            PUBLIC
                FILE_SET public_modules_${target_name}
                TYPE CXX_MODULES
                BASE_DIRS ${module_dir}
                FILES ${module_files}
        )
    endif ()

    if (ARG_LINK_LIBS)
        cmake_parse_arguments(LINK_LIBS_ARG
            ""
            ""
            "PUBLIC;PRIVATE"
            ${ARG_LINK_LIBS}
        )
        foreach (link_lib ${LINK_LIBS_ARG_PUBLIC})
            target_link_libraries(${target_name} PUBLIC ${link_lib})
        endforeach ()
        foreach (link_lib ${LINK_LIBS_ARG_PRIVATE})
            target_link_libraries(${target_name} PRIVATE ${link_lib})
        endforeach ()
    endif ()
endfunction()

add_subdirectory(lib)
add_subdirectory(cli)
