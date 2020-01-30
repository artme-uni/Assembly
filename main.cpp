#include <cmath>
#include <iostream>

int main()
{
    double x = -0.5;
    long n = 100;

    double result = 0;

    for (long i = 1; i < n; i++)
    {
        if (i % 2 == 0)
            result -= pow(x, i) / i;
        else
            result += pow(x, i) / i;
    }

    std::cout << result;

    return 0;
}