add_executable(example main.cpp)

target_sources(example
	PRIVATE
		FILE_SET example_module
		TYPE CXX_MODULES
		BASE_DIRS ${CMAKE_SOURCE_DIR}/modules
		FILES ${CMAKE_SOURCE_DIR}/modules/example/Mod.ixx
) # so that `import example;` imports every library

target_link_libraries(example PRIVATE Alpha)
