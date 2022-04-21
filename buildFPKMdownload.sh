#make sure that old FPKM/ is archived.  
mkdir /home/wen/GenomicExprDownload/FPKMDownload/FPKM/
mkdir /home/wen/GenomicExprDownload/FPKMDownload/FPKM/b_malayi/
mkdir /home/wen/GenomicExprDownload/FPKMDownload/FPKM/c_brenneri/
mkdir /home/wen/GenomicExprDownload/FPKMDownload/FPKM/c_briggsae/
mkdir /home/wen/GenomicExprDownload/FPKMDownload/FPKM/c_elegans/
mkdir /home/wen/GenomicExprDownload/FPKMDownload/FPKM/c_japonica/
mkdir /home/wen/GenomicExprDownload/FPKMDownload/FPKM/c_remanei/
mkdir /home/wen/GenomicExprDownload/FPKMDownload/FPKM/o_volvulus/
mkdir /home/wen/GenomicExprDownload/FPKMDownload/FPKM/p_pacificus/
mkdir /home/wen/GenomicExprDownload/FPKMDownload/FPKM/s_ratti/
/home/wen/GenomicExprDownload/FPKMDownload/bin/dumpSampleConditionAce.sh
/home/wen/GenomicExprDownload/FPKMDownload/bin/makeSampleTable.pl
mv /home/wen/GenomicExprDownload/FPKMDownload/RNAseqSample.csv /home/wen/GenomicExprDownload/FPKMDownload/FPKM/.
cp /home/wen/simpleMine/sourceFile/WBGeneName.csv /home/wen/GenomicExprDownload/FPKMDownload/FPKM/.
/home/wen/GenomicExprDownload/FPKMDownload/bin/createGeneFPKM.pl bma
/home/wen/GenomicExprDownload/FPKMDownload/bin/createGeneFPKM.pl cbn
/home/wen/GenomicExprDownload/FPKMDownload/bin/createGeneFPKM.pl cbg
/home/wen/GenomicExprDownload/FPKMDownload/bin/createGeneFPKM.pl ce
/home/wen/GenomicExprDownload/FPKMDownload/bin/createGeneFPKM.pl cja
/home/wen/GenomicExprDownload/FPKMDownload/bin/createGeneFPKM.pl cre
/home/wen/GenomicExprDownload/FPKMDownload/bin/createGeneFPKM.pl ovo
/home/wen/GenomicExprDownload/FPKMDownload/bin/createGeneFPKM.pl ppa
/home/wen/GenomicExprDownload/FPKMDownload/bin/createGeneFPKM.pl sra
