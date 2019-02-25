/* CSCI 563 Programming Assignment 2 Part 2
   Clayton Kramp
*/
#include <iostream>
#include <fstream>

using namespace std;

// Device function to transpose matrix
__global__ void transpose(int* A, int* B, int row, int col) {

    int j = blockIdx.x * blockDim.x + threadIdx.x;
    int i = blockIdx.y * blockDim.y + threadIdx.y;

    if (i >= row || j >= col) return;
    B[j*row + i] = A[i*col + j];
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        cerr << "Arguments error" << endl;
        return -1;
    }
    ifstream file(argv[1]);
    if (!file.good()) {
        cerr << "Bad input" << endl;
        return -1;
    }
    int row, col;
    file >> col >> row;

    int** A = new int*[row];
    A[0] = new int[row*col];
    for (int i = 1; i < row; i++) A[i] = A[i-1] + col;

    // Fill in matrix A in host
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < col; j++) {
            int element;
            file >> element;
            A[i][j] = element;
        }
    }
    
    file.close();

    int* count = new int;
    *count = 0;

    // Copy matrix to device memory
    int* deviceA;
    int bytes = row * col * sizeof(int);
    cudaMalloc(&deviceA, bytes);
    cudaMemcpy(deviceA, A[0], bytes, cudaMemcpyHostToDevice);
    
    // Create the fill in matrix
    int** B = new int*[col];
    B[0] = new int[row*col];
    for (int i = 1; i < col; i++) B[i] = B[i-1] + row;
    
    int* deviceB;
    cudaMalloc(&deviceB, bytes);

    dim3 threadsPerBlock(8, 8, 1);
    dim3 numBlocks((col + threadsPerBlock.x-1) / threadsPerBlock.x,
                   (row + threadsPerBlock.y-1) / threadsPerBlock.y, 1);

    // Call the actual function
    transpose<<<numBlocks, threadsPerBlock>>>(deviceA, deviceB, row, col);
    //cudaDeviceSynchronize();

    // Copy back the memory
    cudaMemcpy(B[0], deviceB, bytes,  cudaMemcpyDeviceToHost);

    // Print out the info to console
    cout << row << " " << col << endl;
    for (int i = 0; i < col; i++) {
        for (int j = 0; j < row; j++) {
            cout << B[i][j] << " ";
        }
        cout << endl;
    }

    delete A[0];
    delete A;
    delete B[0];
    delete B;

    cudaFree(deviceA);
    cudaFree(deviceB);

    return 0;
}
