#!/bin/csh
#-------------prepare expression cluster ace files ---------------------
setenv ACEDB /home/citace/WS/acedb/
## from Wen
/usr/local/bin/tace -tsuser 'wen' <<END_TACE
QUERY FIND Analysis Database = SRA*; follow Sample
show -a -f /home/wen/GenomicExprDownload/FPKMDownload/ace_files/RNAseqSample.ace
show -a -t Genotype -f /home/wen/GenomicExprDownload/FPKMDownload/ace_files/NoStrainSample.ace
QUERY FIND Analysis Database = SRA*; follow Sample; follow Life_stage
show -a -t Public_name -f /home/wen/GenomicExprDownload/FPKMDownload/ace_files/LifeStageName.ace
QUERY FIND Analysis Database = SRA*; follow Sample; follow Tissue
show -a -t Term -f /home/wen/GenomicExprDownload/FPKMDownload/ace_files/AnatomyName.ace
QUERY FIND Analysis Database = SRA*
show -a -t Title -f /home/wen/GenomicExprDownload/FPKMDownload/ace_files/DatasetTitle.ace
show -a -t Reference -f /home/wen/GenomicExprDownload/FPKMDownload/ace_files/DatasetRef.ace
QUERY FIND Strain
show -a -f /home/wen/GenomicExprDownload/FPKMDownload/ace_files/StrainGenotype.ace
QUERY FIND Strain Genotype = *wild*
show -a -t Genotype -f /home/wen/GenomicExprDownload/FPKMDownload/ace_files/WildTypeStrain.ace
quit
END_TACE
