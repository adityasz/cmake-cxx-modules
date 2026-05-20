module example.d.two;

import example.a;
import example.b;

namespace example {
namespace d {

int two() { return a::two() * b::two(); }

} // namespace d
} // namespace example
