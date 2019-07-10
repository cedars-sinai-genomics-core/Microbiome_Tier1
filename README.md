# Microbiome

####Version 1 is the original one, having different check points; Version 2 combine all of steps into one

####Good review paper  
https://www.nature.com/articles/nrg3129
https://www.nature.com/articles/s41579-018-0029-9
####common issues are usually from PCR bias(primer bias, length bias)
####common sequencing layout: 2X300bp on MiSeq

Analysis for ITS1 and 16S (Version2)

Pipeline running:

###The pipeline must be run under genomics account

```bash
$ source activate qiime1
```

```bash
$ nohup bash /common/genomics-core/apps/microbiome/pipeline.sh > log.txt 2>&1&
```

####Step 1:  Trim primers with cutadapt
####Forward primer(19-20bp) and reverse primer(~22bp) are used to amplify the variable regions(from 18S to 5.8S for ITS as example) to identify the microbiome species
####Screen out reads that do not begin with primer sequence and remove primer sequences from reads 

* R1 start with Forward primer and end with reverse complementary Reverse primer
* R2 start with Reverse primer and end with reverse complementary Forward primer
* Linked adapters trimming was used here to discard reads without containing both primers (—discard-untrimmed) 
* Trimmed reads are written to the output files by the -o and -p (for paired-end reads, the second read in a pair is always written to the file specified by -p)
* Get log file for each sample


####Step 2: merge overlapped paired-end reads (overlapping region >50bp) into a single longer reads. 
When overlapped regions (>50bp) of two reads shows >90% similarity, we consider they are overlapped. Then performing merging and output the merged reads into  -s $1.16S_joined.fastq.gz.
-o <minimum overall base pair overlap to merge two reads; default = 15>  (15bp or 50bp)
If similarity is <90%, then both reads were screened out. ??
If overlapping region is <50bp or not overlap at all, R1 will be output as -1 $1.16S_unassembled_R1.fastq.gz and R2 will be output as -2 $1.16S_unassembled_R2.fastq.gz. Then only $1.16S_unassembled_R1.fastq.gz will be used for QIIME (R1 always shows better sequencing quality than R2).  


####Step 3: Check read length and modify format headline for QIIME
* Merge joined.fastq.gz and unassembled_R1.fastq.gz
* Modify headline (>SampleID_XXXXXXX) ensure no "_" within SampleID, all letters before "_" will be treated as SampleID. Be aware of number of samples started and number of samples processed.
* Discard reads if length < 100bp (this setting is artificial)
* Convert FASTQ to FASTA (QIIME1 prefers FASTA and QIIME2 prefers FASTQ)
* Output file is $1_16S.fasta

####Step 4: QIIME
* Merge all $1_16S.fasta files into one 16S file 
* Merge all $1_ITS.fasta files into one ITS file  
* Alignment (local alignment, BLAST; parallel_pick_otus_blast.py): -b,  to assign database to blast against; -O modify number of jobs to start according to the number of available CPU (do not take all available CPU here); The output consists of two files (i.e. seqs_otus.txt and seqs_otus.log)
* Generate OTU table (make_otu_table.py; tabulates the number of times an OTU is found in each sample, and adds the taxonomic predictions for each OTU in the last column if a taxonomy file is supplied "-t /home/genomics/genomics/reference/Microbiome/$2.fasta.taxonomy"; output is a biom format) (Deliverable #1)
* Generate OTU table (make_otu_table.py; tabulates the number of times an OTU is found in each sample, and adds the taxonomic predictions for each OTU in the last column if a taxonomy file is supplied "-t /home/genomics/genomics/reference/Microbiome/$2.fasta.taxonomy"; output is a biom format) (Deliverable #1)
* Convert biom to txt format (Deliverable #2)
* Count the number of aligned reads per sample (biom summarize-table)  


References: /home/genomics/genomics/reference/Microbiome/  
  16S:  
  gg_13_5_97: green gene database for 16S  
  
  ITS1:  
  THFv1.5: Targeted host-associated fungi (THF) database  
  THFv1.62: the latest version for ITS; default database for ITS  
  ntF-ITS1: nt-Fungi-ITS1 database for mycobiota analysis  
  
  ITS1,2:  
  RTL_20190319: NCBI RefSeq Targeted Loci database (ITS)  
  sh_refs_qiime_ver8: standard QIIME UNITE database, version8 (ITS)  



Deliverables:
* QC table (raw reads; reads with primers and %; assembled reads and %; mapped reads and %; )
* OTU table in both biom and txt formats 

QC to check:  
% mapped reads: >70% (16S) and >60% (ITS)   
Recommend >5000 aligned reads per sample  

####Notes
* QIIME v1 is more mature than QIIME v2 and QIIME v2 has problem of over clustering  
* Other tools to consider: DaDa, Mothur  
* To evaluate the new database, it is good to compare the mapping% (unique mapping)  
