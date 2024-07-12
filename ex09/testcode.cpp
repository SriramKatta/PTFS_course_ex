#include <iostream>
#include <omp.h>

int main()
{
    int i;
    long hist[10] = {0};
    long hist2[5][2] = {0};
#pragma omp parallel for
    {
        for (size_t i = 0; i < 10; i++)
        {
            printf("thread id is : %d index is : %zu\n",  omp_get_thread_num(), i);
        }
    }
    return 0;
}
