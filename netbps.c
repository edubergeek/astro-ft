#include <stdio.h>
#include <math.h>
#include <malloc.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char**argv)
{
  int n = 0;
  double mb, MBps, Mbps;
  long sec;

  int T = 8;
  int N = 2;
  if(argc > 1)
    T = atoi(argv[1]);
  if(argc > 2)
    N = atoi(argv[2]);

  double *totMB = 0;
  long *maxSec = 0;
  double totalMB = 0;
  long totalSec = 0;

  long lenTOTMB = sizeof(*totMB)*N;
  totMB = (double*)malloc(lenTOTMB);
  memset(totMB, 0, lenTOTMB);

  long lenMAXSEC = sizeof(*maxSec)*N;
  maxSec = (long*)malloc(lenMAXSEC);
  memset(maxSec, 0, lenMAXSEC);

  for(n=0;scanf("%lf %ld %lf %lf\n", &mb, &sec, &MBps, &Mbps) == 4;n++)
  {
    printf("%lf MB %ld sec \n", mb, sec);
    int t = n / T;
    if(sec > maxSec[t])
      maxSec[t] = sec;
    totMB[t] += mb;
  }
  for(n=0; n<N; n++)
  {
    totalMB += totMB[n];
    totalSec += maxSec[n];
  }
  printf("%lf MB in %ld seconds\n", totalMB, totalSec);
  MBps = totalMB / (double)totalSec;
  Mbps = MBps * 8.0;
  printf("%lf MB/sec %lf Mbps \n", MBps, Mbps);
  exit(0);
}
