# astro-ft
Astronomy data file transfer evaluator

## Install
E.g. to download the Pan-STARRS PS1-STRM photoz redshift catalog:
```sh
git clone https://github.com/edubergeek/astro-ft.git
cd astro-ft
```

## Prepare the download manifest
```sh
bash spider-manifest.sh http://dtn-itc.ifa.hawaii.edu/ps1/wise-photo-z/
bash manifest.sh
```

## Start the download
```sh
bash run_doWget.bsh
```

## Abort the download
To abort I find it easiest to:
```sh
skill bash
skill wget
```

## Monitor progress
You can monitor the progress with:
```sh
tail -f wget.log
```

To see system performance in real time (e.g. disk write, network usage) I use atop. Once it displays data I press 'd' once.
```sh
sudo atop 10
```

## Controlling parallel threads and resource usage
### Set number of parallel file downloads
You can control the degree of parallelism when you run manifest.sh by adding the number of desired threads as a single numeric argument:
```sh
# Download 4 files at a time
bash manifest.sh 4
32 files in manifest
4 threads
8 files per thread
```

## Performance summary
After a download is finished you can check the performance thusly:
```sh
bash throughput.sh
...
218044497920.000000 bytes in 477 seconds
218.0 GB 477 seconds
457.116364 MB/sec
14.627724 Gbps
```

## Parallel performance
The 32 csv files will begin to download, **8 files at a time by default**.
On a 100G network this typically uses ~**12Gbps** of bandwidth


Curt Dodds
October 2, 2022
