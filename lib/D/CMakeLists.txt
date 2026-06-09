add_example_library(D
    one.cpp
    two.cpp

    MODULES
        d.ixx
        one.ixx
        two.ixx

    LINK_LIBS
        PUBLIC A C
        PRIVATE B
)
