module example.Bravo;

import :Support;
import example.Alpha;

import std;

namespace example {

std::string bravo_impl() { return "Hello, world!"; }

int bravo() { return alpha(bravo_impl()); }

} // namespace example
