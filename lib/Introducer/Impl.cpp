module example.Introducer;

import :Internal;
import example.Greeter;

import std;

namespace example {

std::string internal_function(std::string_view name)
{
	return std::format("My name is {}.", name);
}

std::string introduce(std::string_view name)
{
	return std::format("{} {}", greet(), internal_function(name));
}

} // namespace example
