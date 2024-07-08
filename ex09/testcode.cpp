#include <omp.h>
#include <stdio.h>

int main() {
    int i;

    #pragma omp parallel for //private(i)
    for (i = 0; i < 10; i++) {
        printf("Thread %d: i = %d\n", omp_get_thread_num(), i);
    }

    return 0;
}
