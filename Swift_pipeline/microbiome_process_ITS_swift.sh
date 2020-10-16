PRIMERS=/common/genomics-core/data/Temp/Sequence_Temp/MiSeq/Fastq_Generation/190802_M03606_0082_000000000-CJWMT_07_51_37/Genomics-Core-Microbiome-Kit-Test_Core_Genomics_Others/scripts/swift_ITS1_primer.fastq
#Primer for ITS1
#mkdir ITS1_temp
#mkdir fasta_ITS1
#/common/genomics-core/anaconda2/bin/cutadapt -e 0.10 -g file:$PRIMERS -G file:$PRIMERS --discard-untrimmed -o ./ITS_temp/$1_R1_ITS1.fastq.gz -p ./ITS_temp/$1_R2_ITS1.fastq.gz  $1_R1_001.fastq.gz $1_R2_001.fastq.gz >./ITS_temp/$1_ITS1.log

/common/genomics-core/anaconda2/bin/cutadapt -e 0.10 -g file:$PRIMERS -G file:$PRIMERS --discard-untrimmed -o ./ITS_temp/$1_R1_ITS1.fastq.gz -p ./ITS_temp/$1_R2_ITS1.fastq.gz  $1_R1_001_trimmed.fastq.gz $1_R2_001_trimmed.fastq.gz >./ITS_temp/$1_ITS1.log

##### Paired-end Reads Merging #####
/common/genomics-core/anaconda2/bin/SeqPrep -f ./ITS_temp/$1_R1_ITS1.fastq.gz  -r ./ITS_temp/$1_R2_ITS1.fastq.gz  -1 ./ITS_temp/$1.ITS1_unassembled_R1.fastq.gz -2 ./ITS_temp/$1.ITS1_unassembled_R2.fastq.gz -s ./ITS_temp/$1.ITS1_joined.fastq.gz

##### Formatting for QIIME #####
zcat ./ITS_temp/$1.ITS1_joined.fastq.gz ./ITS_temp/$1.ITS1_unassembled_R1.fastq.gz |cut -f1,5- -d':'|sed s/@M03606:/\>$1_/|awk '{y= i++ % 4 ; L[y]=$0; if(y==1 && length(L[1])>100) {printf("%s\n%s\n",L[0],L[1]);}}' >fasta_ITS/$1_ITS1.fasta




#Primer for  ITS2
#mkdir ITS2_temp
#mkdir fasta_ITS2
#PRIMERS1=./scripts/swift_ITS2_primer.fastq
#/common/genomics-core/anaconda2/bin/cutadapt -e 0.10 -g file:$PRIMERS1 -G file:$PRIMERS1 --discard-untrimmed -o ./ITS2_temp/$1_R1_ITS2.fastq.gz -p ./ITS2_temp/$1_R2_ITS2.fastq.gz  $1_R1_001.fastq.gz $1_R2_001.fastq.gz >./ITS2_temp/$1_ITS2.log

##### Paired-end Reads Merging #####
#/common/genomics-core/anaconda2/bin/SeqPrep -f ./ITS2_temp/$1_R1_ITS2.fastq.gz  -r ./ITS2_temp/$1_R2_ITS2.fastq.gz  -1 ./ITS2_temp/$1.ITS2_unassembled_R1.fastq.gz -2 ./ITS2_temp/$1.ITS2_unassembled_R2.fastq.gz -s ./ITS2_temp/$1.ITS2_joined.fastq.gz

##### Formatting for QIIME #####
#zcat ./ITS2_temp/$1.ITS2_joined.fastq.gz ./ITS2_temp/$1.ITS2_unassembled_R1.fastq.gz |cut -f1,5- -d':'|sed s/@M03606:/\>$1_/|awk '{y= i++ % 4 ; L[y]=$0; if(y==1 && length(L[1])>100) {printf("%s\n%s\n",L[0],L[1]);}}' >fasta_ITS2/$1_ITS2.fasta
