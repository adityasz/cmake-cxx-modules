add_example_library(C
    one.cpp
    two.cpp

    MODULES
        c.ixx
        one.ixx
        two.ixx

    LINK_LIBS
        PUBLIC B
)
