module example.c.two;

import example.b;

namespace example {
namespace c {

int two() { return b::two(); }

} // namespace c
} // namespace example
