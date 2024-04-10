#include<stdio.h>

void main()
{
    int n = 0;
    int i = 0;
    int flag = 0;
    n = 17;
    for (i=2;i<n; i = i+1) {
        int t1 = n - i;
        int t2 = n / i;
        int t3 = t1 * t2;
        (t2 = = n) ? flag = 1: flag = 0;
    }
}
