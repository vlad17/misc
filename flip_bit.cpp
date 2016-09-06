// Compile with g++ -std=c++11 -Wall -O3 flip_bit.cpp -o flip_bit
// Pass --bench flag if you want to benchmark implementations

#include <array>
#include <algorithm>
#include <cctype>
#include <chrono>
#include <cstdlib>
#include <iostream>
#include <limits>
#include <string>
#include <sstream>
#include <stack>
#include <tuple>
#include <queue>
#include <utility>
#include <vector>

unsigned flip_bits(unsigned in) {
  unsigned out = 0;
  for (int i = 0; i < 32; ++i) {
    out |= (!!(in & (1 << i))) << (31 - i);
  }
  return out;
}

// 130 KB table
static const std::array<unsigned short, 1 << 16> lookup = ([]() {
    std::array<unsigned short, 1 << 16> x;
    for (unsigned i = 0; i < x.size(); ++i) {
      x[i] = flip_bits(i) >> 16;
    }
    return x;
  })();


unsigned flip_bits_opt(unsigned in) {
  return ((unsigned) lookup[in >> 16]) + (lookup[in & ((1 << 16) - 1)] << 16);
}

std::string print_int(unsigned x) {
  std::stringstream s;
  for (int i = 31; i >= 0; --i) {
    s << ((x & (1 << i)) ? "1" : "0");
  }
  return s.str();
}

int do_bench() {
  std::vector<unsigned> v(4000); // 16KB, fit in L1
  int seed = std::chrono::system_clock::now().time_since_epoch().count();
  srand(seed);
  std::cout << "Using seed " << seed << " measurments in sys time" << std::endl;
  for (auto& i : v) i = rand();
  auto cpy = v;

  for (auto& i : v) i = flip_bits(i); // warmup
  auto start = std::chrono::system_clock::now();
  for (int i = 0; i < 11; ++i) for (auto& i : v) i = flip_bits(i);
  auto end = std::chrono::system_clock::now();
  if (!std::equal(cpy.begin(), cpy.end(), v.begin())) {
    std::cout << "Reference impl wrong!" << std::endl;
    return 1;
  }
  auto t = std::chrono::duration_cast<std::chrono::microseconds>(
      end - start).count();
  std::cout << "Reference impl time: " << t << " us" << std::endl;

  for (auto& i : v) i = flip_bits_opt(i); // warmup (just icache now)
  start = std::chrono::system_clock::now();
  for (int i = 0; i < 11; ++i) for (auto& i : v) i = flip_bits_opt(i);
  end = std::chrono::system_clock::now();
  if (!std::equal(cpy.begin(), cpy.end(), v.begin())) {
    std::cout << "      opt impl wrong!" << std::endl;
    return 1;
  }
  t = std::chrono::duration_cast<std::chrono::microseconds>(
      end - start).count();
  std::cout << "      opt impl time: " << t << " us" << std::endl;

  return 0;
}

int main(int argc, char *argv[]) {
  if (argc == 2 && std::string("--bench") == argv[1]) {
    return do_bench();
  }

  unsigned in;
  std::cout << "Input unsigned int: ";
  std::cout.flush();

  std::cin >> in;
  unsigned out = flip_bits(in);

  std::cout << "Bit-flipped int: " << out << std::endl;
  std::cout << "input:  " << print_int(in) << std::endl;
  std::cout << "output: " << print_int(out) << std::endl;
  std::cout << "opt:    " << print_int(flip_bits_opt(in)) << std::endl;
  return 0;
}
