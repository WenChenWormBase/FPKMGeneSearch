# FPKMGeneSearch
1. dumpSampleConditionAce.sh

From WS release, dump
AnatomyName.ace,
DatasetTitle.ace,
LifeStageName.ace,
RNAseqSample.ace

2. makeSampleTable.pl

From the ace files, create RNAseqSample.csv file.

3. createGeneFPKM.pl

From /home/wen/WormBaseToSPELL/ create WBGeneXXXXXXXX.csv files for nine species.

4. buildFPKMdownload.sh

A shell script that perform the whole pipeline.
