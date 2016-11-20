import std.stdio;
import std.math;


int multiples35()
{
	int s = 0;
	foreach (i ; 0 .. 1000)
	{
		if (i % 3 == 0 || i % 5 == 0)
			s+=i;
	}
	return s;
}

void main()
{
	writeln(multiples35());
}
