#include <iostream>
#include <fstream>

using namespace std;

int countOnes(int** A, int row, int col) {
    int count = 0;
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < col; j++) {
            if (A[i][j] == 1) count++;
        }
    }
    return count;
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        cerr << "Arguments error" << endl;
        return -1;
    }
    ifstream file(argv[1]);
    int row, col;
    file >> row >> col;

    int** A = new int*[row];
    A[0] = new int[row * col];
    for (int i = 1; i < row; ++i) A[i] = A[i-1] + col;

    for (int i = 0; i < row; i++) {
        for (int j = 0; j < col; j++) {
            int element;
            file >> element;
            A[i][j] = element;
        }
    }

    file.close();

    int count = countOnes(A, row, col);

    cout << "There are " << count << "  ones in this matrix" << endl;

    delete A[0];
    delete A;

    return 0;
}
