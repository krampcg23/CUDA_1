#include <iostream>
#include <fstream>
#include <stdlib.h>

using namespace std;

int main() {
    ofstream f;
    int x = 1;
    f.open("m7.txt");
    f << 1561 << " " << 1251 << endl;
    for (int i = 0; i < 1561; i++) {
        for (int j = 0; j < 1251; j++) {
            f << x << " ";
        }
        f << endl;
    }
    f.close();
    return 0;
}
