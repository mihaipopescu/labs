import std.stdio;
import std.math;


bool isPalindrome(int n)
{
	int s = n;
	int k = 0;
	while(n>0)
	{
		k = (10*k) + (n%10);
		n /= 10;
	}
	return k == s;
}

int largestPalindromeFactor()
{
	int max = 0;
	for (int x=999; x>=1; x--)
	{
		for (int y=999; y>=1; y--)
		{
			int p = x*y;

			if (p < max)
				break;

			if(isPalindrome(p))
			{
				if (p > max)
				{
					max = p; 
				}
			}
		}
	}
	return max;
}


void main()
{
	writeln(largestPalindromeFactor());
}
