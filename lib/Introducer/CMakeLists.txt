add_example_library(Introducer
    PUBLIC
        Introducer.ixx
    PRIVATE
        Internal.ixx
        Impl.cpp
)

target_link_libraries(Introducer PRIVATE Greeter)
