module example.d.one;

import example.a;
import example.b;

namespace example {
namespace d {

int one() { return a::one() * b::one(); }

} // namespace d
} // namespace example
