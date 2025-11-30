add_library(Alpha STATIC)

target_sources(Alpha
	PUBLIC
	FILE_SET alpha_modules
	TYPE CXX_MODULES
	BASE_DIRS ${CMAKE_SOURCE_DIR}/modules
	FILES ${CMAKE_SOURCE_DIR}/modules/example/Alpha/Mod.ixx
)

target_sources(Alpha
	PRIVATE
	Impl.cpp
)
