module;

#include <cstring>

export module example.Alpha;

namespace example {
	/// Just to show how headers can be included in modules
	int minusstrlen(const char *s) { return -static_cast<int>(strlen(s)); }

	export void alpha();
} // namespace example
