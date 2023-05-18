#include <iostream>

extern "C" {
	void my_strcpy(char* to, char* from, size_t len);
}

size_t my_strlen(const char* strpntr) {
	size_t len = 0;
	__asm {
		push ECX
		push EDI
		mov ECX, -1
		mov AL, 0
		mov EDI, strpntr
		repne scasb
		not ECX
		dec ECX
		mov len, ECX
		pop EDI
		pop ECX
	}
	return len;
}

int main() {
	char testString[] = "Testing string for an assembly lab";
	std::cout << "init: " << testString << std::endl;

	size_t len = my_strlen(testString);
	std::cout << "len: " << len << std::endl;

	char copied[100] = { '\0' };

	my_strcpy(copied, testString, len);

	std::cout << "copy: " << copied << std::endl;

	return 0;
}
