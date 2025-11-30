---
title: "Modules (since C++20) - cppreference.com"
source: "https://cppreference.com/w/cpp/language/modules.html"
author:
published:
created: 2025-11-30
description:
tags:
  - "clippings"
---
## Modules (since C++20)

< [cpp](https://cppreference.com/w/cpp.html "cpp") | [language](https://cppreference.com/w/cpp/language.html "cpp/language")

[C++ language](https://cppreference.com/w/cpp/language.html "cpp/language")

Most C++ projects use multiple translation units, and so they need to share [declarations](https://cppreference.com/w/cpp/language/declarations.html "cpp/language/declarations") and [definitions](https://cppreference.com/w/cpp/language/definition.html "cpp/language/definition") across those units. The usage of [headers](https://cppreference.com/w/cpp/standard_library.html#Headers "cpp/standard library") is prominent for this purpose, an example being the [standard library](https://cppreference.com/w/cpp/standard_library.html "cpp/standard library") whose declarations can be provided by [including the corresponding header](https://cppreference.com/w/cpp/standard_library.html#Including_headers "cpp/standard library").

Modules are a language feature to share declarations and definitions across translation units. They are an alternative to some use cases of headers.

Modules are orthogonal to [namespaces](https://cppreference.com/w/cpp/language/namespace.html "cpp/language/namespace").

```cpp
// helloworld.cpp
export module helloworld; // module declaration
 
import <iostream>;        // import declaration
 
export void hello()       // export declaration
{
    std::cout << "Hello world!\n";
}
```

```cpp
// main.cpp
import helloworld; // import declaration
 
int main()
{
    hello();
}
```

### \[edit\] Syntax

<table><tbody><tr><td colspan="10"></td></tr><tr><td><code><b>export</b></code> <span>(optional)</span> <code><b>module</b></code> <span>module-name module-partition</span> <span>(optional)</span> <span>attr</span> <span>(optional)</span><code><b>;</b></code></td><td>(1)</td><td></td></tr><tr><td colspan="10"></td></tr><tr><td><code><b>export</b></code> <span>declaration</span></td><td>(2)</td><td></td></tr><tr><td colspan="10"></td></tr><tr><td><code><b>export {</b></code> <span>declaration-seq</span> <span>(optional)</span> <code><b>}</b></code></td><td>(3)</td><td></td></tr><tr><td colspan="10"></td></tr><tr><td><code><b>export</b></code> <span>(optional)</span> <code><b>import</b></code> <span>module-name attr</span> <span>(optional)</span><code><b>;</b></code></td><td>(4)</td><td></td></tr><tr><td colspan="10"></td></tr><tr><td><code><b>export</b></code> <span>(optional)</span> <code><b>import</b></code> <span>module-partition attr</span> <span>(optional)</span><code><b>;</b></code></td><td>(5)</td><td></td></tr><tr><td colspan="10"></td></tr><tr><td><code><b>export</b></code> <span>(optional)</span> <code><b>import</b></code> <span>header-name attr</span> <span>(optional)</span><code><b>;</b></code></td><td>(6)</td><td></td></tr><tr><td colspan="10"></td></tr><tr><td><code><b>module;</b></code></td><td>(7)</td><td></td></tr><tr><td colspan="10"></td></tr><tr><td><code><b>module&nbsp;: private;</b></code></td><td>(8)</td><td></td></tr><tr><td colspan="10"></td></tr></tbody></table>

1) Module declaration. Declares that the current translation unit is a *module unit*.

2,3) Export declaration. Export all namespace-scope declarations in declaration or declaration-seq.

7) Starts a [global module fragment](https://cppreference.com/w/cpp/language/modules.html#Global_module_fragment).

8) Starts a [private module fragment](https://cppreference.com/w/cpp/language/modules.html#Private_module_fragment).

### \[edit\] Module declarations

A translation unit may have a module declaration, in which case it is considered a *module unit*. The *module declaration*, if provided, must be the first declaration of the translation unit (excepted the *global module fragment*, which is covered later on). Each module unit is associated to a *module name* (and optionally a partition), provided in the module declaration.

<table><tbody><tr><td colspan="10"></td></tr><tr><td><code><b>export</b></code> <span>(optional)</span> <code><b>module</b></code> <span>module-name module-partition</span> <span>(optional)</span> <span>attr</span> <span>(optional)</span><code><b>;</b></code></td><td></td><td></td></tr><tr><td colspan="10"></td></tr></tbody></table>

The module name consists of one or more identifiers separated by dots (for example: `mymodule`, `mymodule.mysubmodule`, `mymodule2`...). Dots have no intrinsic meaning, however they are used informally to represent hierarchy.

If any identifier in the module name or module partition is defined as an [object-like macro](https://cppreference.com/w/cpp/preprocessor/replace.html "cpp/preprocessor/replace"), the program is ill-formed.

A *named module* is the collection of module units with the same module name.

Module units whose declaration has the keyword export are termed *module interface units*; all other module units are termed *module implementation units*.

For every named module, there must be exactly one module interface unit that specifies no module partition; this module unit is termed the *primary module interface unit*. Its exported content will be available when importing the corresponding named module.

```cpp
// (each line represents a separate translation unit)
 
export module A;   // declares the primary module interface unit for named module 'A'
module A;          // declares a module implementation unit for named module 'A'
module A;          // declares another module implementation unit for named module 'A'
export module A.B; // declares the primary module interface unit for named module 'A.B'
module A.B;        // declares a module implementation unit for named module 'A.B'
```

### \[edit\] Exporting declarations and definitions

Module interface units can export declarations (including definitions), which can be imported by other translation units. To export a declaration, either prefix it with the export keyword, or else place it inside an export block.

<table><tbody><tr><td colspan="10"></td></tr><tr><td><code><b>export</b></code> <span>declaration</span></td><td></td><td></td></tr><tr><td colspan="10"></td></tr><tr><td><code><b>export {</b></code> <span>declaration-seq</span> <span>(optional)</span> <code><b>}</b></code></td><td></td><td></td></tr><tr><td colspan="10"></td></tr></tbody></table>

```cpp
export module A; // declares the primary module interface unit for named module 'A'
 
// hello() will be visible by translations units importing 'A'
export char const* hello() { return "hello"; } 
 
// world() will NOT be visible.
char const* world() { return "world"; }
 
// Both one() and zero() will be visible.
export
{
    int one()  { return 1; }
    int zero() { return 0; }
}
 
// Exporting namespaces also works: hi::english() and hi::french() will be visible.
export namespace hi
{
    char const* english() { return "Hi!"; }
    char const* french()  { return "Salut!"; }
}
```

### \[edit\] Importing modules and header units

Modules are imported via an *import declaration*:

<table><tbody><tr><td colspan="10"></td></tr><tr><td><code><b>export</b></code> <span>(optional)</span> <code><b>import</b></code> <span>module-name attr</span> <span>(optional)</span><code><b>;</b></code></td><td></td><td></td></tr><tr><td colspan="10"></td></tr></tbody></table>

All declarations and definitions exported in the module interface units of the given named module will be available in the translation unit using the import declaration.

Import declarations can be exported in a module interface unit. That is, if module `B` export-imports `A`, then importing `B` will also make visible all exports from `A`.

In module units, all import declarations (including export-imports) must be grouped after the module declaration and before all other declarations.

```cpp
/////// A.cpp (primary module interface unit of 'A')
export module A;
 
export char const* hello() { return "hello"; }
 
/////// B.cpp (primary module interface unit of 'B')
export module B;
 
export import A;
 
export char const* world() { return "world"; }
 
/////// main.cpp (not a module unit)
#include <iostream>
import B;
 
int main()
{
    std::cout << hello() << ' ' << world() << '\n';
}
```

[#include](https://cppreference.com/w/cpp/preprocessor/include.html "cpp/preprocessor/include") should not be used in a module unit (outside the *global module fragment*), because all included declarations and definitions would be considered part of the module. Instead, headers can also be imported as *header units* with an *import declaration*:

<table><tbody><tr><td colspan="10"></td></tr><tr><td><code><b>export</b></code> <span>(optional)</span> <code><b>import</b></code> <span>header-name attr</span> <span>(optional)</span><code><b>;</b></code></td><td></td><td></td></tr><tr><td colspan="10"></td></tr></tbody></table>

A header unit is a separate translation unit synthesized from a header. Importing a header unit will make accessible all its definitions and declarations. Preprocessor macros are also accessible (because import declarations are recognized by the preprocessor).

However, contrary to #include, preprocessing macros already defined at the point of the import declaration will not affect the processing of the header. This may be inconvenient in some cases (some headers use preprocessing macros as a form of configuration), in which case the usage of *global module fragment* is needed.

```cpp
/////// A.cpp (primary module interface unit of 'A')
export module A;
 
import <iostream>;
export import <string_view>;
 
export void print(std::string_view message)
{
    std::cout << message << std::endl;
}
 
/////// main.cpp (not a module unit)
import A;
 
int main()
{
    std::string_view message = "Hello, world!";
    print(message);
}
```

### \[edit\] Global module fragment

Module units can be prefixed by a *global module fragment*, which can be used to include headers when importing the headers is not possible (notably when the header uses preprocessing macros as configuration).

<table><tbody><tr><td colspan="10"></td></tr><tr><td><code><b>module;</b></code><p><span>preprocessing-directives</span> <span>(optional)</span></p><p><span>module-declaration</span></p></td><td></td><td></td></tr><tr><td colspan="10"></td></tr></tbody></table>

If a module-unit has a global module fragment, then its first declaration must be `**module;**`. Then, only [preprocessing directives](https://cppreference.com/w/cpp/preprocessor.html#Directives "cpp/preprocessor") can appear in the global module fragment. Then, a standard module declaration marks the end of the global module fragment and the start of the module content.

```cpp
/////// A.cpp (primary module interface unit of 'A')
module;
 
// Defining _POSIX_C_SOURCE adds functions to standard headers,
// according to the POSIX standard.
#define _POSIX_C_SOURCE 200809L
#include <stdlib.h>
 
export module A;
 
import <ctime>;
 
// Only for demonstration (bad source of randomness).
// Use C++ <random> instead.
export double weak_random()
{
    std::timespec ts;
    std::timespec_get(&ts, TIME_UTC); // from <ctime>
 
    // Provided in <stdlib.h> according to the POSIX standard.
    srand48(ts.tv_nsec);
 
    // drand48() returns a random number between 0 and 1.
    return drand48();
}
 
/////// main.cpp (not a module unit)
import <iostream>;
import A;
 
int main()
{
    std::cout << "Random value between 0 and 1: " << weak_random() << '\n';
}
```

### \[edit\] Private module fragment

Primary module interface unit can be suffixed by a *private module fragment*, which allows a module to be represented as a single translation unit without making all of the contents of the module reachable to importers.

<table><tbody><tr><td colspan="10"></td></tr><tr><td><code><b>module&nbsp;: private;</b></code><p><span>declaration-seq</span> <span>(optional)</span></p></td><td></td><td></td></tr><tr><td colspan="10"></td></tr></tbody></table>

*Private module fragment* ends the portion of the module interface unit that can affect the behavior of other translation units. If a module unit contains a *private module fragment*, it will be the only module unit of its module.

```cpp
export module foo;
 
export int f();
 
module : private; // ends the portion of the module interface unit that
                  // can affect the behavior of other translation units
                  // starts a private module fragment
 
int f()           // definition not reachable from importers of foo
{
    return 42;
}
```

### \[edit\] Module partitions

A module can have *module partition units*. They are module units whose module declarations include a module partition, which starts with a colon `**:**` and is placed after the module name.

```cpp
export module A:B; // Declares a module interface unit for module 'A', partition ':B'.
```

A module partition represents exactly one module unit (two module units cannot designate the same module partition). They are visible only from inside the named module (translation units outside the named module cannot import a module partition directly).

A module partition can be imported by module units of the same named module.

<table><tbody><tr><td colspan="10"></td></tr><tr><td><code><b>export</b></code> <span>(optional)</span> <code><b>import</b></code> <span>module-partition attr</span> <span>(optional)</span><code><b>;</b></code></td><td></td><td></td></tr><tr><td colspan="10"></td></tr></tbody></table>

```cpp
/////// A-B.cpp   
export module A:B;
...
 
/////// A-C.cpp
module A:C;
...
 
/////// A.cpp
export module A;
 
import :C;
export import :B;
 
...
```

All definitions and declarations in a module partition are visible by the importing module unit, whether exported or not.

Module partitions can be module interface units (when their module declarations have `**export**`). They must be export-imported by the primary module interface unit, and their exported statements will be visible when the module is imported.

<table><tbody><tr><td colspan="10"></td></tr><tr><td><code><b>export</b></code> <span>(optional)</span> <code><b>import</b></code> <span>module-partition attr</span> <span>(optional)</span><code><b>;</b></code></td><td></td><td></td></tr><tr><td colspan="10"></td></tr></tbody></table>

```cpp
///////  A.cpp   
export module A;     // primary module interface unit
 
export import :B;    // Hello() is visible when importing 'A'.
import :C;           // WorldImpl() is now visible only for 'A.cpp'.
// export import :C; // ERROR: Cannot export a module implementation unit.
 
// World() is visible by any translation unit importing 'A'.
export char const* World()
{
    return WorldImpl();
}
```

```cpp
/////// A-B.cpp 
export module A:B; // partition module interface unit
 
// Hello() is visible by any translation unit importing 'A'.
export char const* Hello() { return "Hello"; }
```

```cpp
/////// A-C.cpp 
module A:C; // partition module implementation unit
 
// WorldImpl() is visible by any module unit of 'A' importing ':C'.
char const* WorldImpl() { return "World"; }
```

```cpp
/////// main.cpp 
import A;
import <iostream>;
 
int main()
{
    std::cout << Hello() << ' ' << World() << '\n';
    // WorldImpl(); // ERROR: WorldImpl() is not visible.
}
```

### \[edit\] Module ownership

In general, if a declaration appears after the module declaration in a module unit, it is *attached to* that module.

If a declaration of an entity is attached to a named module, that entity can only be defined in that module. All declarations of such an entity must be attached to the same module.

If a declaration is attached to a named module, and it is not exported, the declared name has [module linkage](https://cppreference.com/w/cpp/language/storage_duration.html#Module_linkage "cpp/language/storage duration").

```cpp
export module lib_A;
 
int f() { return 0; } // f has module linkage
export int x = f();   // x equals 0
```

```cpp
export module lib_B;
 
int f() { return 1; } // OK, f in lib_A and f in lib_B refer to different entities
export int y = f(); // y equals 1
```

If [two declarations of an entity](https://cppreference.com/w/cpp/language/conflicting_declarations.html#Multiple_declarations_of_the_same_entity "cpp/language/conflicting declarations") are attached to different modules, the program is ill-formed; no diagnostic is required if neither is reachable from the other.

```cpp
/////// decls.h
int f(); // #1, attached to the global module
int g(); // #2, attached to the global module
```

```cpp
/////// Module interface of M
module;
#include "decls.h"
export module M;
export using ::f; // OK, does not declare an entity, exports #1
int g();          // Error: matches #2, but attached to M
export int h();   // #3
export int k();   // #4
```

```cpp
/////// Other translation unit
import M;
static int h();   // Error: matches #3
int k();          // Error: matches #4
```

The following declarations are not attached to any named module (and thus the declared entity can be defined outside the module):

- [namespace](https://cppreference.com/w/cpp/language/namespace.html "cpp/language/namespace") definitions with external linkage;
- declarations within a [language linkage](https://cppreference.com/w/cpp/language/language_linkage.html "cpp/language/language linkage") specification.

```cpp
export module lib_A;
 
namespace ns // ns is not attached to lib_A.
{
    export extern "C++" int f(); // f is not attached to lib_A.
           extern "C++" int g(); // g is not attached to lib_A.
    export              int h(); // h is attached to lib_A.
}
// ns::h must be defined in lib_A, but ns::f and ns::g can be defined elsewhere (e.g.
// in a traditional source file).
```

### \[edit\] Notes

| [Feature-test](https://cppreference.com/w/cpp/utility/feature_test.html "cpp/utility/feature test") macro | Value | Std | Feature |
| --- | --- | --- | --- |
| [`__cpp_modules`](https://cppreference.com/w/cpp/experimental/feature_test.html#cpp_modules "cpp/feature test") | [`201907L`](https://cppreference.com/w/cpp/compiler_support/20.html#cpp_modules_201907L "cpp/compiler support/20") | (C++20) | Modules — core language support |
| [`__cpp_lib_modules`](https://cppreference.com/w/cpp/experimental/feature_test.html#cpp_lib_modules "cpp/feature test") | [`202207L`](https://cppreference.com/w/cpp/compiler_support/23.html#cpp_lib_modules_202207L "cpp/compiler support/23") | (C++23) | [Standard library modules](https://cppreference.com/w/cpp/standard_library.html#Importing_modules "cpp/standard library") std and std.compat |

### \[edit\] Keywords

[private](https://cppreference.com/w/cpp/keyword/private.html "cpp/keyword/private"),[module](https://cppreference.com/w/cpp/identifier_with_special_meaning/module.html "cpp/identifier with special meaning/module"),[import](https://cppreference.com/w/cpp/identifier_with_special_meaning/import.html "cpp/identifier with special meaning/import"),[export](https://cppreference.com/w/cpp/keyword/export.html "cpp/keyword/export")

### \[edit\] Defect reports

The following behavior-changing defect reports were applied retroactively to previously published C++ standards.

| DR | Applied to | Behavior as published | Correct behavior |
| --- | --- | --- | --- |
| [CWG 2732](https://cplusplus.github.io/CWG/issues/2732.html) | C++20 | it was unclear whether importable headers can   react to preprocessor state from the point of import | no reaction |
| [P3034R1](https://wg21.link/P3034R1) | C++20 | module names and module partitions could   contain identifiers defined as object-like macros | prohibited |
