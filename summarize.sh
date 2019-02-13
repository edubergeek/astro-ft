#! /bin/bash 
for i in wget?*.log
do
  tail -2 $i | head -1
done

grep '100%' *.log | tr '\r' '\n' | grep '100%'   |  awk '{print $2, $3, $5, $6}' | sed -e 's/MB\/s//' | tr 'Gms' '   '  |awk '{gsub(",", "", $1);bytes=bytes+$1;mbs=mbs+$2;if(NF==4)secs=secs+($3*60+$4); else secs=secs+$3; } END {printf("%d bytes in %d seconds\n", bytes, secs); printf("Average MB/s %.1f\n", mbs/2); printf("Average Mbps %.1f\n", 8*mbs/2); printf("Average MB/s/thread %.1f\n",mbs/2/NR*2);}'
#grep '100%' *.log | tr '\r' '\n' | grep '100%'   |  awk '{print $2, $3, $5, $6}' | sed -e 's/MB\/s//' | tr 'Gms' '   '  |awk '{gsub(",", "", $1);bytes=bytes+$1;mbs=mbs+$2;if(NF==4)secs=secs+($3*60+$4); else secs=secs+$3;} END { mbps=8*bytes/1e6/secs*(NR/2); printf("%.1f GB in %d seconds\n", bytes/1e9, secs); printf("Avg Mbps %.1f\n",mbps); printf("Avg MB/sec %.1f\n", mbps/8); printf("Avg MB/sec/thread %.1f\n",mbps/8/(NR/2) ); print mbs/NR}'
#grep '100%' *.log | tr '\r' '\n' | grep '100%'   |  awk '{MB=int($3*1000.0); min=int($6); if(int($7)==0){ sec=min; min=0;} else {sec=min*60+int($7)} print MB, sec, MB/sec, MB*8/sec; }'
