#include <iostream>
#include <ctime>
#include <chrono>

using namespace std;

#define N 4
#define TIMES 1e6

typedef struct vector
{
    float list[N];
} vector_t;

void cout_time(clock_t time, const char* action)
{
    if (time >= 1000)
        cout << action << ": " << ((double)time) / CLOCKS_PER_SEC / TIMES << " s." << endl;
    else
        cout << action << ": " << ((double)time) / TIMES << " ms." << endl;
}

float scalarMulty(const vector_t v1, const vector_t v2)
{
    float scalar = 0;
    clock_t start_time, res_time = 0;
    for (int i = 0; i < TIMES; i++)
    {
        scalar = 0;
        start_time = clock();
        for (int i = 0; i < N; i++)
            scalar += v1.list[i] * v2.list[i];
        res_time += clock() - start_time;
    }
    cout_time(res_time, "ScalarMulty: ");
    return scalar;
}

float asmScalar(const vector_t v1, const vector_t v2)
{
    float result = 0;
    clock_t start_time, res_time = 0;
    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        __asm
        {
            movups xmm0, v1.list
            movups xmm1, v2.list
            mulps xmm0, xmm1
            movhlps xmm1, xmm0
            addps xmm0, xmm1
            movups xmm1, xmm0
            shufps xmm0, xmm0, 1
            addps xmm0, xmm1
            movss result, xmm0
        }
        res_time += clock() - start_time;
    }
    cout_time(res_time, "ASM: ");
    return result;
}

int main()
{
    vector_t v1 = { 1, 2, 3, 4 };
    vector_t v2 = { 4, 3, 2, 1 };
    cout << scalarMulty(v1, v2) << endl;
    cout << asmScalar(v1, v2) << endl;
    return EXIT_SUCCESS;
}
