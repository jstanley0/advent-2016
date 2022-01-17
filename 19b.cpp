#include <iostream>
#include <vector>
#include <cstdio>

using namespace std;

int main(int argc, char **argv)
{
    if (argc < 2) {
        cout << "usage: 19b elfcount\n";
        return 1;
    }
    int elfcount = atoi(argv[1]);

    vector<int> elves;
    elves.reserve(elfcount);
    for(int elf = 1; elf <= elfcount; ++elf)
        elves.push_back(elf);

    size_t i = 0;
    while(elves.size() > 1) {
        // this is so painful
        size_t sz = elves.size();
        size_t k = (i + sz/2) % sz;
        elves.erase(elves.begin() + k);
        if (i < k)
            ++i;
        if (i >= elves.size())
            i = 0;
    }

    cout << elves[0] << endl;
    return 0;
}
