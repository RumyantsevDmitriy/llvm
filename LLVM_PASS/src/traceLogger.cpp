#include <iostream>

extern "C" void instrTrace(const char* InstrName, const char* UserInstrName)
{   
    if (UserInstrName != nullptr)
    {
        std::cout << InstrName;
        std::cout << " <- " << UserInstrName;
        std::cout << '\n';
    }
}