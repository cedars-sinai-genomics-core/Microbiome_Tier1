mkdir 16S_temp
mkdir fasta_16S
for sample in `ls *R1*fastq.gz`
do
base=$(basename $sample "_R1_001.fastq.gz")
qsub -q highmem.q -N pre -cwd /common/genomics-core/data/Temp/Sequence_Temp/MiSeq/Fastq_Generation/190802_M03606_0082_000000000-CJWMT_07_51_37/Genomics-Core-Microbiome-Kit-Test_Core_Genomics_Others/scripts/microbiome_process_16S_swift.sh ${base}
#qsub -q highmem.q -N pre -cwd /common/genomics-core/data/Temp/Sequence_Temp/MiSeq/Fastq_Generation/190802_M03606_0082_000000000-CJWMT_07_51_37/Genomics-Core-Microbiome-Kit-Test_Core_Genomics_Others/scripts/microbiome_process_16S.sh ${base}
done

#mkdir ITS_temp
#mkdir fastq_ITS
#for sample in `ls Swift-ITS*R1*fastq.gz`
#do
#base=$(basename $sample "_R1_001_trimmed.fastq.gz")
#qsub -q highmem.q -N pre -cwd /common/genomics-core/data/Temp/Sequence_Temp/MiSeq/Fastq_Generation/190802_M03606_0082_000000000-CJWMT_07_51_37/Genomics-Core-Microbiome-Kit-Test_Core_Genomics_Others/scripts/microbiome_process_ITS_swift.sh ${base}
#done


qsub -q highmem.q -hold_jid pre -sync y -N qiime1 -cwd /common/genomics-core/apps/microbiome/qiime_workflow_16S_1.sh
echo "sleep 120 && echo 'Running a job...'" | qsub

qsub -q highmem.q -hold_jid qiime1,POTU*,STDIN -sync y -cwd /common/genomics-core/apps/microbiome/qiime_workflow_16S_2.sh 16S
echo "sleep 120 && echo 'Running a job...'" | qsub

#qsub -q highmem.q -hold_jid pre,qiime1,POTU*,STDIN -sync y -N qiime2 -cwd /common/genomics-core/apps/microbiome/qiime_workflow_ITS1_1.sh
#echo "sleep 120 && echo 'Running a job...'" | qsub

#qsub -q highmem.q -hold_jid qiime2,POTU*,STDIN -sync y -cwd /common/genomics-core/apps/microbiome/qiime_workflow_ITS1_2.sh ITS1


#qsub -q highmem.q -hold_jid pre,qiime2,POTU*,STDIN -sync y -N qiime3 -cwd /common/genomics-core/apps/microbiome/qiime_workflow_ITS2_1.sh
#echo "sleep 120 && echo 'Running a job...'" | qsub

#qsub -q highmem.q -hold_jid qiime3,POTU*,STDIN -cwd /common/genomics-core/apps/microbiome/qiime_workflow_ITS2_2.sh ITS2

mkdir log
mv POTU* pre.* log

# count raw reads for 16S samples
#for i in `ls  Swift-All*_R1*gz | sort`; do zcat $i | echo $i $((`wc -l`/4)) ; done >16S_raw_reads.txt
# count raw reads for ITS1 samples
#for i in `ls  ITS1*_R1*gz | sort`; do zcat $i | echo $i $((`wc -l`/4)) ; done >ITS1_raw_reads.txt
# count raw reads for ITS2 samples
#for i in `ls  ITS2*_R1*gz | sort`; do zcat $i | echo $i $((`wc -l`/4)) ; done  >ITS2_raw_reads.txt

# count the number of trimmed reads for ITS samples
#for i in `ls  ITS_temp/*_R1_ITS*gz | sort`; do zcat $i | echo $i $((`wc -l`/4)) ; done > ./ITS_trimmed_reads.txt

# count the number of trimmed reads for 16S samples
for i in `ls  16S_temp/*_R1_16S*gz | sort`; do zcat $i | echo $i $((`wc -l`/4)) ; done > ./16S_trimmed_reads.txt

# count assembled reads for 16S samples
for i in `ls  fasta_16S/16S*16S.fasta | sort`; do cat $i | echo $i $((`wc -l`/2)) ; done >16S_assembled_reads.txt
# count assembled reads for ITS samples
#for i in `ls  fasta_ITS/ITS*ITS*.fasta | sort`; do cat $i | echo $i $((`wc -l`/2)) ; done >ITS_assembled_reads.txt
