import std.stdio;
import std.math;


int evenFibLess4M()
{
	int i = 0, s = 0;
	int f0 = 1;
	int f1 = 1;

	while(s < 4000000)
	{
		// compute fib
		int f = f0 + f1;
		f0 = f1;
		f1 = f;

		if (f % 2 == 0)
		{
			s += f;
		}
	}

	return s;
}

void main()
{
	writeln(evenFibLess4M());
}
