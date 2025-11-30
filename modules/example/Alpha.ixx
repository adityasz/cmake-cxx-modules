module;

#include <cstring>

export module example.Alpha;

import std;

namespace example {
	/// Just to show how headers can be included in modules
	int minusstrlen(const char *s) { return -static_cast<int>(strlen(s)); }

	export int alpha(std::string_view s);
} // namespace example
