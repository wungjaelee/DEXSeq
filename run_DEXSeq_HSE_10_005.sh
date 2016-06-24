#PBS -S /bin/bash
#PBS -j oe
#PBS -q buyin
#PBS -A b1036
#PBS -l walltime=120:00:00
#PBS -l nodes=1
#PBS -N DEXSeq_HES
cd $PBS_O_WORKDIR
module load python
module load R

#Concatenate RNA fastq files first into reads 1 and reads2
cat /projects/b1036/xvault/150506_D00306_0525_AC5VH2ACXX/Project_Jc435/Sample_10_005/10_005_ACAGTG_L004_R1*.fastq.gz > /projects/b1036/wung/DEXSeq/HES/10_005_READS/10_005_ACAGTG_L004_R1.fastq.gz
cat /projects/b1036/xvault/150506_D00306_0525_AC5VH2ACXX/Project_Jc435/Sample_10_005/10_005_ACAGTG_L004_R2*.fastq.gz > /projects/b1036/wung/DEXSeq/HES/10_005_READS/10_005_ACAGTG_L004_R2.fastq.gz
#Running STAR aligner step 1, generating genome indices
/projects/b1036/SOFTWARE/STAR-STAR_2.4.2a/bin/Linux_x86_64/STAR --runThreadN 22 --runMode genomeGenerate --genomeDir /projects/b1036/wung/DEXSeq/HES/genomeINDEX --genomeFastaFiles /projects/b1036/REFERENCE/Homo_sapiens.GRCh38.dna.primary_assembly.fa --sjdbGTFfile /projects/b1036/REFERENCE/Homo_sapiens.GRCh38.84.gtf
#Running STAR aligner step 2, generating SAM file for given RNA fastq
/projects/b1036/SOFTWARE/STAR-STAR_2.4.2a/bin/Linux_x86_64/STAR --runThreadN 22 --genomeDir /projects/b1036/wung/DEXSeq/HES/genomeINDEX --readFilesCommand zcat --readFilesIn /projects/b1036/wung/DEXSeq/HES/10_005_READS/10_005_ACAGTG_L004_R1.fastq.gz /projects/b1036/wung/DEXSeq/HES/10_005_READS/10_005_ACAGTG_L004_R2.fastq.gz --outFileNamePrefix /projects/b1036/wung/DEXSeq/HES/STAR_OUTPUT/10_005_
#Running two python scripts to prepare data before running R
python /projects/b1036/SHARED/R_MODULES/DEXSeq/python_scripts/dexseq_prepare_annotation.py /projects/b1036/REFERENCE/Homo_sapiens.GRCh38.84.gtf /projects/b1036/wung/Homo_sapiens.GRCh38.84.DEXSeq.gff
python /projects/b1036/SHARED/R_MODULES/DEXSeq/python_scripts/dexseq_count.py Homo_sapiens.GRCh38.84.DEXSeq.gff 10_005_Aligned.out.sam 10_005_fb.txt
