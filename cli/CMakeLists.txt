add_executable(example main.cpp)

target_sources(example
    PRIVATE
        FILE_SET example_module
        TYPE CXX_MODULES
        BASE_DIRS ${CMAKE_SOURCE_DIR}/modules/example
        FILES ${CMAKE_SOURCE_DIR}/modules/example/example.ixx
)

target_link_libraries(example
    PRIVATE
        A
        B
        C
        D
)
