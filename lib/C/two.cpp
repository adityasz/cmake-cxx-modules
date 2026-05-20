module example.c.two;

import example.b.two;

namespace example {
namespace c {

int two(b::S2) { return b::two(); }

} // namespace c
} // namespace example
