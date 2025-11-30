add_example_library(Bravo
    PUBLIC
        Bravo.ixx
    PRIVATE
        Internal.ixx
        Impl.cpp
)

target_link_libraries(Bravo PRIVATE Alpha)
