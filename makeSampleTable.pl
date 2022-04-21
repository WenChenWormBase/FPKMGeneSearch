#!/usr/bin/perl

#-------------------Type out the purpose of the script-------------
print "This program create RNAseq Sample Condition table.\n";
print "Input file: LifeStageName.ace\n";
print "Input file: AnatomyName.ace\n";
print "Input file: DatasetTitle.ace\n";
print "Input file: RNAseqSample.ace\n";
print "Output file: RNAseqSample.csv\n\n";

my ($line, $ls, $lsname, $ao, $aoname, $spe, $sex, $treatment, $tissue, $srx, $lifeStage, $analysis, $title);
my @tmp;
my %lsName;
my %aoName;
my %daTitle;

#------------- Get Life Stage names ---------------------------------------------

open (LS, "/home/wen/GenomicExprDownload/FPKMDownload/ace_files/LifeStageName.ace") || die "can't open LifeStageName.ace!";
while ($line=<LS>) {
    if ($line =~ /^Life_stage/) {
	@tmp = split '"', $line;
	$ls = $tmp[1];
    } elsif ($line =~ /^Public_name/) {
	@tmp = split '"', $line;
	$lsname = $tmp[1];
	$lsName{$ls} = $lsname;
    }
}
close (LS);
#--------------------------- done getting Life Stage names -------------------------------


#------------- Get anatomy names ---------------------------------------------

open (AO, "/home/wen/GenomicExprDownload/FPKMDownload/ace_files/AnatomyName.ace") || die "can't open AnatomyName.ace!";
while ($line=<AO>) {
    if ($line =~ /^Anatomy_term/) {
	@tmp = split '"', $line;
	$ao = $tmp[1];
    } elsif ($line =~ /^Term/) {
	@tmp = split '"', $line;
	$aoname = $tmp[1];
	$aoName{$ao} = $aoname;
    }
}
close (AO);
#------- done getting anatomy names -------------------------------


#------- Get Wild Type Strain list -------------
my $strain;
my %wtStrain;
open (WT, "/home/wen/GenomicExprDownload/FPKMDownload/ace_files/WildTypeStrain.ace") || die "can't open WildTypeStrain.ace!";
while ($line=<WT>) {
    if ($line =~ /^Strain/) {
	@tmp = split '"', $line;
	$strain = $tmp[1];
	$wtStrain{$strain} = 1;
    }
}
close (WT);
#------- done getting WT strain list -------------------------------


#--------- Get all genotype ----------------------
my ($geno, $sname);
my %strainGeno;
my %strainName;
open (GTP, "/home/wen/GenomicExprDownload/FPKMDownload/ace_files/StrainGenotype.ace") || die "can't open StrainGenotype.ace!";
while ($line=<GTP>) {
    if ($line =~ /^Strain/) {
	@tmp = split '"', $line;
	$strain = $tmp[1];
	$geno = "";
	$sname = "";
    } elsif  ($line =~ /^Genotype/) {
	@tmp = split '"', $line;
	$geno = $tmp[1];
	#print "$strain, $geno\n";
	$strainGeno{$strain} = $geno;
    } elsif  ($line =~ /^Public_name/) {
	@tmp = split '"', $line;
	$sname = $tmp[1];
	#print "$strain, $geno\n";
	$strainName{$strain} = $sname;
    }
}
close (GTP);
# -------- done getting strain genotype -------

#------------- Get dataset title ---------------------------------------------
open (DA, "/home/wen/GenomicExprDownload/FPKMDownload/ace_files/DatasetTitle.ace") || die "can't open DatasetTitle.ace!";
while ($line=<DA>) {
    if ($line =~ /^Analysis/) {
	@tmp = split '"', $line;
	$analysis = $tmp[1];
    } elsif ($line =~ /^Title/) {
	@tmp = split '"', $line;
	$title = $tmp[1];
	$daTitle{$analysis} = $title;
    }
}
close (DA);
#------- done getting anatomy names -------------------------------


#------------- Get dataset reference ---------------------------------------------
my $ref;
my %daRef;
open (DR, "/home/wen/GenomicExprDownload/FPKMDownload/ace_files/DatasetRef.ace") || die "can't open DatasetRef.ace!";
while ($line=<DR>) {
    if ($line =~ /^Analysis/) {
	@tmp = split '"', $line;
	$analysis = $tmp[1];
    } elsif ($line =~ /^Reference/) {
	@tmp = split '"', $line;
	$ref = $tmp[1];
	$daRef{$analysis} = $ref;
    }
}
close (DR);
#------- done getting anatomy names -------------------------------


#------ get dataset treatment category -----------
my %refTreat;
my @stuff;
open (RT, "/home/wen/WormBaseToSPELL/bin/SPELLDataSet_Topics_annotation.csv") || die "can't open /home/wen/WormBaseToSPELL/bin/SPELLDataSet_Topics_annotation.csv!";
$line=<RT>;
while ($line=<RT>) {
    @tmp = ();
    @tmp = split /\t/, $line;
    @stuff = split /\./, $tmp[0];
    $ref= $stuff[0];
    if ($tmp[1] =~ /immune response/) {
	$refTreat{$ref} = "Immune response";
	#print "$ref, Immune Response\n";
    } elsif  ($tmp[1] =~ /chemical/) {
	$refTreat{$ref} = "Chemical response";
	#print "$ref, Chemical Response\n";
    } elsif  ($tmp[1] =~ /starvation/) {
        $refTreat{$ref} = "Food response";
    } elsif  ($tmp[1] =~ /temperature stimulus/) {
        $refTreat{$ref} = "Temperature stimulus";
    } elsif  ($tmp[1] =~ /RNAi gene function/) {
        $refTreat{$ref} = "RNAi";
    }

}
close (RT);
#----- done getting dataset category ----


#------ Get patched Strain and Treatment info ----------
#open (PAT, "/home/wen/GenomicExprDownload/FPKMDownload/ace_files/SRX_strain_patch.csv") || die "can't open SRX_strain_patch.csv!";
#my %srxStrain;
#my%srxTreatment;
#$line = <PAT>;
#while ($line =<PAT>) {
#    chomp($line);
#    @tmp = ();
#    @tmp = split /\t/, $line;
#    $srx = $tmp[4];
#    $strain = join "", "Mutant: ", $tmp[4], "[$tmp[5]]";
#    $srxStrain{$srx} = $strain;
#    if ($tmp[6]) {
#	if ($tmp[6] =~ /RNAi/) {
#	    $treament  = join ": ", "RNAi", $treatment;
#	    $srxTreatment{$srx} = $treatment;
#	}
#    }    
#}
#close (PAT);


#---------------- Get Sample Condition ------------------------------------
open (IN, "/home/wen/GenomicExprDownload/FPKMDownload/ace_files/RNAseqSample.ace") || die "can't open RNAseqSample.ace!";
open (OUT, ">/home/wen/GenomicExprDownload/FPKMDownload/RNAseqSample.csv") || die "cannot open RNAseqSample.csv!\n";

print OUT "Sample Name\tSpecies\tStrain\tLife Stage\tTissue\tTreatment\tTitle\n";

while ($line =<IN>) {
    chomp($line);
    @tmp = ();
    if ($line =~ /^Condition/) {
	#@tmp = split 'SRX', $line;
	#$srx = "SRX$tmp[1]";
	$spe = "";
	$strain = "";
	$lifeStage = "";
	$tissue = "";
	$treatment = "";
	$title = "";
    } elsif ($line =~ /^Life_stage/) {
	@tmp = split '"', $line;
	$ls = $tmp[1];
	if ($lsName{$ls}) {
	    $lifeStage = $lsName{$ls};
	    if ($lifeStage =~ /embryo/i) {
		$lifeStage = join ": ", "Embryo", $lifeStage;
	    } elsif  ($lifeStage =~ /larva/i) {
		$lifeStage = join ": ", "Larva", $lifeStage;		
	    } elsif  ($lifeStage =~ /adult/i) {
		$lifeStage = join ": ", "Adult", $lifeStage;				
	    } elsif ($lifeStage =~ /all stages/) {
		$lifeStage = join ": ", "Mixed stages", $lifeStage;						
	    } else {
		$lifeStage = join ": ", "Unclassified", $lifeStage;
	    }	    
	} else {
	    $lifeStage = "Unclassified: N.A.";
	}	
    } elsif ($line =~ /^Tissue/) {
	@tmp = split '"', $line;
	$ao = $tmp[1];
	if ($aoName{$ao}) {
	    $tissue = $aoName{$ao};
	    if ($tissue =~ /organism/) {
		#$tissue = join ": ", "Whole animal", $tissue;
		$tissue = "Whole animal"; 
	    } else {
		$tissue = join ": ", "Tissue specific", $tissue;
	    }
	} else {
	    $tissue = "N.A.";
	}
    } elsif ($line =~ /^Species/) {
	@tmp = split '"', $line;
	$spe = $tmp[1];
    } elsif ($line =~ /^Strain/) {
	@tmp = split '"', $line;
	$strain = $tmp[1];
	
	next unless ($strainName{$strain});
	$sname = $strainName{$strain};
	if ($wtStrain{$strain}) {
	    $strain = join ": ", "Wild type", $sname;
        } else {
	    if ($strainGeno{$strain}) {
		$geno = $strainGeno{$strain};
		if (($geno =~ /Strongyloides/) || ($geno =~ /Caenorhabditis/)) {
		    $geno = "Genotype N.A.";
		}
		#print "$strain, $geno\n";
	    } else {
		$geno = "Genotype N.A.";
	    }
	    if ($geno eq "Genotype N.A.") {
		$strain = join "", "Unclassified: ", $sname;
	    } else {
		$strain = join "", "Mutant: ", $sname, "[$geno]";
	    }
	}
    } elsif ($line =~ /^Treatment/) {
	@tmp = split '"', $line;
	$treatment = $tmp[1];
	if ($treatment =~ /RNAi/) {
	    $treatment = join ": ", "RNAi", $treatment;
	}
	    
    } elsif ($line =~ /^Analysis/) {
	@tmp = split '"', $line;
	$analysis = $tmp[1];
	@tmp = ();
	if ($analysis =~ /SRX/) {
	    @tmp = split "SRX", $analysis;
	    $srx = "SRX$tmp[1]";
	} elsif ($analysis =~ /ERX/) {
	    @tmp = split "ERX", $analysis;
	    $srx = "ERX$tmp[1]";
	} else {
	    $srx = $analysis;
	}

	if ($daTitle{$analysis}) {
	    $title = $daTitle{$analysis};
	} else {
	    $title = "N.A."
	}

	if ($daRef{$analysis}) {
	    $ref = $daRef{$analysis};
	    $title = join " --", $title, $ref;
	    if ($treatment =~ /^RNAi/) {
		#do nothing
	    } else {
		if ($refTreat{$ref}) {
		    $treatment = join ": ", $refTreat{$ref}, $treatment;
		} elsif ($treatment eq "") {
                    $treatment = "No treatment";
                } else {
		    $treatment = join ": ", "Unclassified", $treatment;
		}
	    }
	}

	if ($strain eq "") {
	    if ($srx{$strain}) {
		$strain = $srx{$strain};
	    } else {
		$strain = "Unclassified: no strain info";
	    }
	} 
	print OUT "$srx\t$spe\t$strain\t$lifeStage\t$tissue\t$treatment\t$title\n";
    }
}

close (IN);
close (OUT);

print "Done printing RNAseq sample table.\n";
