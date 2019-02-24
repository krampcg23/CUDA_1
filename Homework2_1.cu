#include <iostream>
#include <fstream>

using namespace std;


__global__ void countOnes(int* A, int* count, int row, int col) {

    int j = blockIdx.x * blockDim.x + threadIdx.x;
    int i = blockIdx.y * blockDim.y + threadIdx.y;

    if (i >= row || j >= col) return;
    if (A[i * col + j] == 1) {
        atomicAdd(count, 1);
    }
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        cerr << "Arguments error" << endl;
        return -1;
    }
    ifstream file(argv[1]);
    int row, col;
    file >> col >> row;

    int** A = new int*[row];
    A[0] = new int[row*col];
    for (int i = 1; i < row; i++) A[i] = A[i-1] + col;

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

    int* deviceA;
    int bytes = row * col * sizeof(int);
    cudaMalloc(&deviceA, bytes);
    cudaMemcpy(deviceA, A[0], bytes, cudaMemcpyHostToDevice);

    int* deviceCount;
    cudaMalloc(&deviceCount, 4);
    cudaMemcpy(deviceCount, count, 4, cudaMemcpyHostToDevice);

    dim3 threadsPerBlock(8, 8, 1);
    dim3 numBlocks((col + threadsPerBlock.x-1) / threadsPerBlock.x,
                   (row + threadsPerBlock.y-1) / threadsPerBlock.y, 1);

    countOnes<<<numBlocks, threadsPerBlock>>>(deviceA, deviceCount, row, col);
    //cudaDeviceSynchronize();

    cudaMemcpy(count, deviceCount, 4, cudaMemcpyDeviceToHost);

    cout << "There are " << *count << " ones in this matrix" << endl;

    delete A[0];
    delete A;

    cudaFree(deviceA);
    cudaFree(deviceCount);

    return 0;
}
