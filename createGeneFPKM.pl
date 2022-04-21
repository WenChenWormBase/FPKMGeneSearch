#!/usr/bin/perl -w
#This script parse RNAseq expression tables into gene specific .csv files
#for example: WBGene00000001.csv, WBGene00000002.csv

use strict;

if ($#ARGV !=0) {
    die "usage: $0 series_file ace\n";
}
my $specode = $ARGV[0];
my %speName = ("cbg" => "Caenorhabditis briggsae",
	       "cbn" => "Caenorhabditis brenneri",
	       "cja" => "Caenorhabditis japonica",
	       "cre" => "Caenorhabditis remanei",
	       "ce" => "Caenorhabditis elegans",
	       "ppa" => "Pristionchus pacificus",
	       "bma" => "Brugia malayi", 
	       "ovo" => "Onchocerca volvulus", 
	       "sra" => "Strongyloides ratti");
my %speInput = ("cbg" => "/home/wen/WormBaseToSPELL/c_briggsae/",
	       "cbn" => "/home/wen/WormBaseToSPELL/c_brenneri/",
	       "cja" => "/home/wen/WormBaseToSPELL/c_japonica/",
	       "cre" => "/home/wen/WormBaseToSPELL/c_remanei/",
	       "ce" => "/home/wen/WormBaseToSPELL/c_elegans/",
	       "ppa" => "/home/wen/WormBaseToSPELL/p_pacificus/",
	       "bma" => "/home/wen/WormBaseToSPELL/b_malayi/", 
	       "ovo" => "/home/wen/WormBaseToSPELL/o_volvulus/", 
	       "sra" => "/home/wen/WormBaseToSPELL/s_ratti/");
my  %speOutput = ("cbg" => "/home/wen/GenomicExprDownload/FPKMDownload/FPKM/c_briggsae/",
	       "cbn" => "/home/wen/GenomicExprDownload/FPKMDownload/FPKM/c_brenneri/",
	       "cja" => "/home/wen/GenomicExprDownload/FPKMDownload/FPKM/c_japonica/",
	       "cre" => "/home/wen/GenomicExprDownload/FPKMDownload/FPKM/c_remanei/",
	       "ce" => "/home/wen/GenomicExprDownload/FPKMDownload/FPKM/c_elegans/",
	       "ppa" => "/home/wen/GenomicExprDownload/FPKMDownload/FPKM/p_pacificus/",
	       "bma" => "/home/wen/GenomicExprDownload/FPKMDownload/FPKM/b_malayi/", 
	       "ovo" => "/home/wen/GenomicExprDownload/FPKMDownload/FPKM/o_volvulus/", 
	       "sra" => "/home/wen/GenomicExprDownload/FPKMDownload/FPKM/s_ratti/");

if ($speName{$specode}) {
    print "***** Prepare FPKM files for RNAseq data for $speName{$specode} *****\n";    
} else {
    die "Species code $specode is not recognized.\n";
}

my ($line, $gene, $fpkm, $sra, $sra_id, $g_id, $geneSRA, $totalGene, $totalSRA);
my @stuff;
my @geneList;
my %geneExist;
my @expList;
my %expExist;
my %geneSRAvalue;

#------------get the name of all input expr level files --------
my $i = 0;
my @inputfile;

#open (IN1, "exprFileList.txt") || die "cannot open $!\n";
my $fileList = join "", "$speInput{$specode}", "exprFileList.txt"; 
open (IN1, $fileList) || die "cannot open $fileList\n";
while ($line = <IN1>) {
     chomp($line);
     $inputfile[$i] = $line;
     $i++;     
 }
close (IN1);
#------------done getting all the input file names. -----------

my $f; #filename
$sra_id = 0;
$g_id = 0;
foreach $f (@inputfile) {
    
    ($sra, $stuff[0]) = split '\.', $f;
    print "SRA: $sra\n";
    $expList[$sra_id] = $sra;
    $sra_id++;
    
    $f = join "", "$speInput{$specode}", $f;

    open (SRA, "$f") || die "cannot open $f\n";
    while ($line = <SRA>) {
	chomp ($line);
	($gene, $fpkm) = split /\t/, $line;
	if ($geneExist{$gene}) {
	    #do nothing
	} else {
	    $geneExist{$gene} = 1;
	    $geneList[$g_id] = $gene;
	    $g_id++;
	}
	$geneSRA = join "", $gene, $sra;
	$geneSRAvalue{$geneSRA} = $fpkm;
    }
    close (SRA);	
}

$totalSRA = $sra_id + 1;
$totalGene = $g_id +1;
print "$totalSRA RNAseq libraries found.\n";
print "$totalGene genes studied.\n";

foreach $gene (@geneList) {
    $f = join "", "$speOutput{$specode}", $gene, ".csv";
    open (OUT, ">$f") || die "cannot open $f\n";
    print OUT "SRA\t$gene\n";
    foreach $sra (@expList) {
	$geneSRA = join "", $gene, $sra;
	if ($geneSRAvalue{$geneSRA}) {
	    $fpkm = $geneSRAvalue{$geneSRA};
	    print OUT "$sra\t$fpkm\n";
	} else {
	    print OUT "$sra\tN.A.\n";	    
	}
    }
    close (OUT);
}

print "Done printing gene based FPKM tables.\n";
