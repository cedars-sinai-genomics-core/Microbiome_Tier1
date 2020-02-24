#$ -v PATH=/hpc/apps/python27/externals/toolshed/0.4.0/bin:/common/genomics-core/anaconda2/envs/qiime1/bin:/common/genomics-core/anaconda2/condabin:/common/genomics-core/apps/.bds:/common/genomics-core/anaconda2/bin/:/opt/xcat/bin:/opt/xcat/sbin:/opt/xcat/share/xcat/tools:/opt/sge/bin:/opt/sge/bin/lx-amd64:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/wud3/.local/bin:/home/wud3/bin

biom convert -i ITS_OTU_wo_controls.txt -o ITS_OTU_wo_controls.biom --table-type="OTU table" --to-hdf5 --process-obs-metadata taxonomy

biom convert -i 16S_OTU_wo_controls.txt -o 16S_OTU_wo_controls.biom --table-type="OTU table" --to-hdf5 --process-obs-metadata taxonomy
