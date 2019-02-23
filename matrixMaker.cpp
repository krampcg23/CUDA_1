#include <iostream>
#include <fstream>
#include <stdlib.h>

using namespace std;

int main() {
    ofstream f;
    f.open("m6.txt");
    f << 1561 << " " << 1251 << endl;
    for (int i = 0; i < 1561; i++) {
        for (int j = 0; j < 1251; j++) {
            int x = rand() % 5;
            f << x << " ";
        }
        f << endl;
    }
    f.close();
    return 0;
}
