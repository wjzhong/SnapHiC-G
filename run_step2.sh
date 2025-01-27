#!/bin/bash
#PBS -q hotel
#PBS -N snHiC_s2
#PBS -l nodes=10:ppn=1
#PBS -l walltime=50:00:00
#PBS -l mem=1000GB
#PBS -j oe
#PBS -o log.${PBS_JOBNAME}.${PBS_JOBID}.log

### SET THE DIRECTIVES ABOVE IF YOU ARE WORKING IN HPC WITH A JOB SCHEDULER
### AND LOAD THE REQUIRED MODULES IF NEEDED. REQUIRES PYTHON3.6+ WITH 
### MODULES TO BE INSTALLED USING "pip install -r requirements.txt"
#cd ${PBS_O_WORKDIR}
#module load python/3.6.1

############################################################################
###                            User Variables                            ###
############################################################################
snapHiC_G_dir="/path/to/SnapHiC-G"	#where the SnapHiC-G is located on your system
parallelism="parallel" 					#options are "parallel" "threaded" "singleproc"
number_of_processors=10   				#required only if parallelism is set to parallel or threaded
indir="" 						#directory containing input files (e.g. *.pairs files)
suffix="" 						#all input files should have the same suffix. it can be an empty string "", or ".txt"
outdir="" 						#directory where output files will be stored
chrs="" 						#2 integer numbers, the column number of chromosomes in the input files. (e.g. "3 5") starting from 1
pos="" 							#2 integer numbers, the column number of mapped position of read-pairs. (e.g.  "4 6") starting from 1
chrlen="/path/to/SnapHiC-G/ext/mm10.chrom.sizes" 		#path to the chrom.sizes file"
genome="mm10"  						#genomeID that will be used for genereation of ".hic" file 
filter_file="/path/to/SnapHiC-G/ext/mm10_filter_regions.txt" 	#regions to be filtered, for example due to low mappability
tss_file="/path/to/SnapHiC-G/ext/mm10.refGene.transcript.TSS.061421.txt" #transcription start site (TSS) file for the genome of interest
promoter_file="/path/to/SnapHiC-G/ext/ODC.promoters.txt" #promoter file for genes (this input file is optional)
enhancer_file="/path/to/SnapHiC-G/ext/ODC.enhancers.txt" #enhancer file for genes (this input file is optional)
steps="hic interaction postprocess" 					#steps to run the pipeline. Recommended (1) "bin rwr" at first, (2) then  "hic interaction postprocess"
prefix="datset_name"                                    #this will be used as a prefix for output file names
############################################################################


if [[ "$parallelism" == "parallel" ]]; then
	mpirun -np $number_of_processors python $snapHiC_dir/snap.py -i $indir -s $suffix -o $outdir -c $chrs -p $pos -l $chrlen -g $genome --filter-file $filter_file --tss-file $tss_file --promoter-file $promoter_file --enhancer-file $enhancer_file --steps $steps --prefix $prefix --parallel
elif [[ "$parallelism" == "threaded" ]]; then
	python $snapHiC_dir/snap.py -i $indir -s $suffix -o $outdir -c $chrs -p $pos -l $chrlen -g $genome --filter-file $filter_file --tss-file $tss_file --promoter-file $promoter_file --enhancer-file $enhancer_file --steps $steps --prefix $prefix --threaded -n $number_of_processors
else
	python $snapHiC_dir/snap.py -i $indir -s $suffix -o $outdir -c $chrs -p $pos -l $chrlen -g $genome --filter-file $filter_file --tss-file $tss_file --promoter-file $promoter_file --enhancer-file $enhancer_file --steps $steps --prefix $prefix 
fi
