// Vladimir Feinberg 2014-08-24 is_function_defined.cpp

#include <iostream>
#include <memory>
#include <atomic>
#include <string>

using namespace std;

// How to programatically determine whether a function is present or not
// In this case we want to find out if the library supports atomic shared_ptr operations.

// One such function is
// template<class T>
// bool std::atomic_compare_exchange_weak(std::shared_ptr<T>* p, std::shared_ptr<T>* expected, std::shared_ptr desired)

// Use SFINAE -

// We can then go on to provide two implementations for compatibility
template<bool B>
class A;

// Specialization for true, when we can use the libary function
template<> class A<true> { public: string str() { return "implementation can use atomic CAS"; } };

// Specialization for false, when we can't
template<> class A<false> { public: string str() { return "implementation can't use atomic CAS"; } };

int main()
{
    // Use case:
    // clang's lib actually supports the above function where as gcc's doesn't.
    // Try compiling and running this with -stdlib=libc++ (clang) and -stdlib=libstdc++
    A<has_atomic_overloads<shared_ptr<int> >::value> a;
    cout << a.str() << endl;

    return 0;
}
