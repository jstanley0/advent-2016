#include <iostream>
#include <vector>
#include <cstdio>

using namespace std;

size_t find_nonzero_index(const vector<size_t> &presents, size_t start)
{
    for(;;) {
        if (presents[start] != 0) {
            return start;
        }
        if (++start == presents.size())
            start = 0;
    }
}

int main(int argc, char **argv)
{
    if (argc < 2) {
        cout << "usage: 19 elfcount\n";
        return 1;
    }
    size_t elfcount = atoi(argv[1]);

    vector<size_t> presents(elfcount, 1);
    size_t i = 0;
    for(;;) {
        i = find_nonzero_index(presents, i);
        size_t k = find_nonzero_index(presents, (i + 1) % elfcount);
        presents[i] += presents[k];
        if (presents[i] == elfcount) {
            break;
        }
        presents[k] = 0;
        i = (k + 1) % elfcount;
    }
    cout << i + 1 << endl;
    return 0;
}
