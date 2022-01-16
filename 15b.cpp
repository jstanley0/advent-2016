#include <iostream>
#include <fstream>
#include <vector>
#include <regex>
#include <string>

using namespace std;

int main(int argc, char **argv)
{
    if (argc < 2) {
        cerr << "no filename given" << endl;
        return 1;
    }

    regex re{R"(Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+)\.)"};
    ifstream input{argv[1]};
    string line;
    vector<int> addends;
    vector<int> divisors;
    while(getline(input, line)) {
        smatch match;
        if (regex_match(line, match, re)) {
            addends.push_back(stoi(match[1]) + stoi(match[3]));
            divisors.push_back(stoi(match[2]));
        }
    }

    size_t n = addends.size();
    for(size_t i = 0; ; ++i) {
        bool match = true;
        for(size_t j = 0; j < n; ++j) {
            if ((i + addends[j]) % divisors[j] != 0) {
                match = false;
                break;
            }
        }
        if (match) {
            cout << i << endl;
            break;
        }
    }

    return 0;
}
