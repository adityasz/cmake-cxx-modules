# An example of using C++ Modules with CMake

I could not find good examples, so I wrote this.

> [!NOTE]
>
> [GCC bug 122625](https://gcc.gnu.org/bugzilla/show_bug.cgi?id=122625) prevents
> me from using it. GCC 15.3 (unreleased) will have the fix. This project
> currently only supports clang. Tested only on Linux with clang 21.1 and CMake
> 3.31.6.
>
> Modules are still experimental in CMake.
> See `https://github.com/Kitware/CMake/blob/v${cmake_version}/Help/dev/experimental.rst`
> and set `CMAKE_EXPERIMENTAL_CXX_IMPORT_STD` accordingly in the root
> `CMakeLists.txt` before using.

```
.
├── CMakeLists.txt
├── modules
│   ├── example
│   │   ├── Greeter.ixx
│   │   └── Introducer.ixx
│   └── example.ixx
├── lib
│   ├── CMakeLists.txt
│   ├── Greeter
│   │   ├── CMakeLists.txt
│   │   └── Impl.cpp
│   └── Introducer
│       ├── CMakeLists.txt
│       ├── Impl.cpp
│       └── Internal.ixx
└── cli
    ├── CMakeLists.txt
    └── main.cpp
```
