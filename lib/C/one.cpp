module example.c.one;

import example.b;

namespace example {
namespace c {

int one() { return b::one(); }

} // namespace c
} // namespace example
