import std.stdio;
import std.math;


bool isPrime(int n)
{
	for(int i=2; i <= cast(int)sqrt(cast(double)n); i++)
	{
		if (n % i == 0)
			return false;
	}
	return true;
}

int largestPrimeFactor()
{
	long n = 600851475143;
	int max = 0;

	for (int i=2; i<cast(int)sqrt(cast(double)n); i++)
	{
		if (n % i == 0)
		{
			if (isPrime(i))
			{
				writefln("Found another prime: %s", i);
				max = i;
			}
		}
	}
	return max;
}

void main()
{
	writeln(largestPrimeFactor());
}
