module example.d.two;

import example.d.one;
import example.c;
import example.a;
import example.b;

namespace example {
namespace d {

int two(S1, c::S1) { return a::two() * b::two(); }

} // namespace d
} // namespace example
