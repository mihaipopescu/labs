import std.stdio;
import core.stdc.stdlib;
import std.math;
import std.bigint;
import std.parallelism;
import std.algorithm;
import std.range;
import std.typecons;

// Euclid algorithm computing greatest common divisor
T gcd(T) (T u, T v)
{
  T t, k;
 
  u = u < 0 ? -u : u; /* abs(u) */
  v = v < 0 ? -v : v; 
  if (u < v) {
    t = u;
    u = v;
    v = t;
  }
  if (v == 0)
    return u;
 
  k = 1;
  while (((u & 1) == 0) && ((v & 1) == 0)) { /* u, v - even */
    u >>= 1; v >>= 1;
    k <<= 1;
  }
 
  t = (u & 1) ? -v : u;
  while (t) {
    while ((t & 1) == 0) 
      t >>= 1;
 
    if (t > 0)
      u = t;
    else
      v = -t;
 
    t = u - v;
  }
  return u * k; 
}

// http://oeis.org/search?q=6%2C30%2C138%2C606%2C2586&language=english&go=Search
// a(n) = 3*4^n-2*3^n.
void snowflakes1()
{
  int k = 11;
  int[100] a;

  a[0] = 1;

  for (int i=1; i<=k; i++)
  {
    a[i] = 6*a[i-1];
    writef("a[%s] = 6*a[%s]", i+1, i-1+1);

    int t = 0;
    for(int j=0; j<i-1; j++)
    {
      writef(" - 6*a[%s]", i-j-2+1);
      t += 6*a[i-j-2];
    }

    a[i] -= t;
    writefln(" = %s", a[i]);
  }
}

struct triangle
{
  int b;
  int n1;
  int n2;
  int n3;

  void print()
  {
    static char[] c = ['w', 'b', 'r', 'y', 'g', 'p'];
    writef("%s_%s%s%s", b < c.length ? c[b] : 'x', n1 < c.length ? c[n1] : 'x', n2 < c.length ? c[n2] : 'x', n3 < c.length ? c[n3] : 'x');
  }
};

void rotate(triangle t, int level)
{
  write(" ");
  t.print();

  if (level < 5)
  {
    write("->(");

    triangle t1 = { t.n1+1, t.n1, t.n1, t.b+1 };
    rotate(t1, level + 1);

    triangle t2 = { t.n2+1, t.n2, t.n2, t.b+1 };
    rotate(t2, level + 1);

    triangle t3 = { t.n3+1, t.n3, t.n3, t.b+1 };
    rotate(t3, level + 1);

    triangle t4 = { t.b   , t.n1, t.n3, t.b+1 };
    rotate(t4, level + 1);

    triangle t5 = { t.b   , t.n1, t.n2, t.b+1 };
    rotate(t5, level + 1);

    triangle t6 = { t.b   , t.n2, t.n3, t.b+1 };
    rotate(t6, level + 1);

    writeln(")");
  }
}

auto snowflakes_iterative()
{
    const int k = 2000;
    const int w = 3;

    BigInt[w] b;
    BigInt[w] b2r1w;
    BigInt[w] b2w1r;
    BigInt[w] b3r;

    BigInt[w] y;
    BigInt[w] y2r1g;
    BigInt[w] y2g1r;
    BigInt[w] y3r;
    BigInt[w] y3g;

    b[0] = 0;
    b2r1w[0] = 0;
    b2w1r[0] = 6;
    b3r[0] = 0;

    y[0] = 0;
    y3r[0] = 0;
    y2r1g[0] = 0;
    y2g1r[0] = 0;
    y3g[0] = 0;

    BigInt S = 0;

    int l = 0;


    for(int n=1; n<=k-2; n++)
    {
        //
        // b_wwr->( b_wwr b_wwr y_rrr b_wrr b_wwr b_wrr)
        // b_wrr->( b_wwr y_rrr y_rrr b_wrr b_wrr b_rrr)
        // b_rrr->( y_rrr y_rrr y_rrr b_rrr b_rrr b_rrr)
        //
        // y_rrg->( y_rrg y_rrg p_ggg y_rgg y_rrg y_rgg)
        // y_rrr->( y_rrg y_rrg y_rrg y_rrg y_rrg y_rrg)
        // y_rgg->( y_rrg p_ggg p_ggg y_rgg y_rgg y_ggg)
        // y_ggg->( p_ggg p_ggg p_ggg y_ggg y_ggg y_ggg)
        // 

        b2w1r[n%w] = 3*b2w1r[(n-1)%w] + 1*b2r1w[(n-1)%w];
        b2r1w[n%w] = 2*b2w1r[(n-1)%w] + 2*b2r1w[(n-1)%w];
        b3r[n%w]   = 1*b2r1w[(n-1)%w] + 3*b3r[(n-1)%w];

        y3r[n%w]   = 1*b2w1r[(n-1)%w] + 2*b2r1w[(n-1)%w] + 3*b3r[(n-1)%w]; 
        y2r1g[n%w] = 6*y3r[(n-1)%w]   + 3*y2r1g[(n-1)%w] + 1*y2g1r[(n-1)%w];
        y2g1r[n%w] = 2*y2r1g[(n-1)%w] + 2*y2g1r[(n-1)%w];
        y3g[n%w]   = 1*y2g1r[(n-1)%w] + 3*y3g[(n-1)%w];

        b[n%w] = b2w1r[n%w] + b2r1w[n%w] + b3r[n%w];
        y[n%w] = y3r[n%w] + y2r1g[n%w] + y2g1r[n%w] + y3g[n%w];

        BigInt g = gcd(b[n%w], y[n%w]);

        //writefln("a[%s] = %s", n+2, b[n%w]);
        //writefln("b[%s] = %s\n", n+2, y[n%w]);
        //writefln("g[%s] = %s\n", n+2, g);
        writef("%6s ", g/6);

        l++;

        if (l%30 == 0) writeln();

        S += g;
    }

    return S;
}

alias blue = (int n)
{
    return 6*(2*BigInt(4)^^n - BigInt(3)^^n);
};

alias yellow = (int n)
{
    return 6*(BigInt(4)^^n*(3*n - 17) + BigInt(3)^^n*(2*n + 17));
};

alias _gcd = (Tuple!(BigInt, BigInt) x)
{
    return gcd(x[0], x[1]);
};

alias _gcd_by = (int n)
{
    return gcd(blue(n), yellow(n));
};

auto snowflakes_functional()
{
    immutable n = iota(2, 1_000);
    immutable sum = taskPool.reduce!"a+b"(
        n.map!_gcd_by);
    return sum;
}


void main()
{
    auto sum = snowflakes_functional();
    writefln("S = %s", sum);
}
