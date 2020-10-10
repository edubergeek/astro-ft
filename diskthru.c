#include <stdio.h>
#include <math.h>
#include <malloc.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

/*
file size bytes start time end time
Hot_PS1_PV3_31_001_12.bak size 21337769984 start 2018-11-20T17:19:10-1000 end 2018-11-20T17:22:51-1000
Hot_PS1_PV3_27_001_31.bak size 21960083456 start 2018-11-20T17:19:10-1000 end 2018-11-20T17:22:54-1000
Hot_PS1_PV3_29_001_10.bak size 22993248256 start 2018-11-20T17:19:10-1000 end 2018-11-20T17:23:21-1000
Hot_PS1_PV3_30_001_34.bak size 23031926784 start 2018-11-20T17:19:10-1000 end 2018-11-20T17:23:37-1000
Hot_PS1_PV3_31_001_16.bak size 21467475968 start 2018-11-20T17:22:51-1000 end 2018-11-20T17:26:32-1000
Hot_PS1_PV3_27_001_36.bak size 21982683648 start 2018-11-20T17:22:54-1000 end 2018-11-20T17:26:52-1000
Hot_PS1_PV3_29_001_11.bak size 23071675904 start 2018-11-20T17:23:21-1000 end 2018-11-20T17:27:35-1000
Hot_PS1_PV3_30_001_45.bak size 23275502080 start 2018-11-20T17:23:37-1000 end 2018-11-20T17:27:57-1000
*/

long timestampToSec(char*stamp)
{
    struct tm t;
    time_t t_of_day;
    int tzoff = 0;

    sscanf(stamp, "%d-%d-%dT%d:%d:%d-%d", &t.tm_year, &t.tm_mon, &t.tm_mday, &t.tm_hour, &t.tm_min, &t.tm_sec, &tzoff);
    t.tm_isdst = 0;        // Is DST on? 1 = yes, 0 = no, -1 = unknown
    t_of_day = mktime(&t);
    tzoff /= 100;
    t_of_day += tzoff*3600;

    mktime(&t);
    return (long)t_of_day;
}

int main(int argc, char**argv)
{
  int n = 0;
  double mb, MBps, Mbps;
  long bytes, sec;

  int T = 8;
  int N = 2;
  if(argc > 1)
    T = atoi(argv[1]);
  if(argc > 2)
    N = atoi(argv[2]);

  char filename[80];
  char sStart[80];
  char sEnd[80];
  long totalSec = 0;
  float totalB = 0;
  float totalGB = 0;

  mb = 0;
  for(n=0;scanf("%s size %ld start %s end %s\n", filename, &bytes, sStart, sEnd) == 4;n++)
  {
    long gbytes = bytes / 1000 / 1000 / 1000;
    long secs = timestampToSec(sEnd);
    secs -= timestampToSec(sStart);
    printf("%s %ld %s %s : %ldGB %ldsecs \n", filename, bytes, sStart, sEnd, gbytes, secs);
    totalB += bytes;
    totalSec += secs;
  }
  printf("%f bytes in %ld seconds\n", totalB, totalSec);
  printf("%.1f GB %ld seconds\n", totalB / (1000*1000) / 1000, totalSec);
  
  printf("%f MB/sec\n", totalB/totalSec/(1000*1000)*(n/T));
  printf("%f Gbps\n", totalB/totalSec/(1000*1000*1000)*8*(n/T));
  /*
  printf("%lf MB in %ld seconds\n", totalMB, totalSec);
  MBps = totalMB / (double)totalSec;
  Mbps = MBps * 8.0;
  printf("%lf MB/sec %lf Mbps \n", MBps, Mbps);
  */
  exit(0);
}
