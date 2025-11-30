module example.Alpha;

import std;

namespace example {

int alpha(std::string_view s)
{
	// this is terrible
	return minusstrlen(std::string(s).c_str());
}

} // namespace example
