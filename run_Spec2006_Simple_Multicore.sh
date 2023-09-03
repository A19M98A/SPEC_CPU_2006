#!/bin/bash         
##########################################################################################	
##                    Script for running spec2000 workloads	on gem5						##
##$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$##
##NOTE: all of these workloads have been executed for a 3Billion instructions 			##
##HF never waited for completion of all these workloads.								##
##This means that HF is sure that the workloads are doing something,					##
##but is not sure that they are on the right way and produce the correct output.		##
##The input files and the parameters are not necessarily correct, 						##
##but are according to samples provided by SPEC2000 and the workloads					##
##never protested about them. you can test other inputs and parameters.					##
##The script is not necessarily optimized and you can try to improve it.				##
##Please feel free to contact me for any question about the script.						##
##I'll be happy to inform me about your improvements on this script.					##
##					Email:  farbeh@gmail.com											##
##########################################################################################
DibugFlags="FatAndThin"
CACHE=--caches
L2=--l2cache
L2_SIZE="--l2A_size=256kB --l2B_size=256kB --l2C_size=256kB --l2D_size=256kB"
L2_ASSOC="--l2A_assoc=16 --l2B_assoc=16 --l2C_assoc=16 --l2D_assoc=16"
L1D_SIZE=--l1d_size=32kB
L1D_ASSOC=--l1d_assoc=4
L1I_SIZE=--l1i_size=32kB
L1I_ASSOC=--l1i_assoc=4
LINE_SIZE=--cacheline_size=256
# CPU_Type=--cpu-type=TimingSimpleCPU
CPU_Type=--cpu-type=arm_detailed
LOG_DATA_DIR=/home/amin/Documents/Storage/gem5/logs
INPUT_DATA_DIR=/home/amin/Documents/Storage/cpu2006/data
BINARY_DIR=/home/amin/Documents/Storage/cpu2006/binaries
GEM5_ROOT=/home/amin/Documents/Storage/gem5
MAX_INST=--maxinsts=4000000000
FF=--fast-forward=4000000000
OUT_FILE1=L1d_LHD_log_file
OUT_FILE2=L1d_LHD_log_file_perBlk
OUT_FILE3=L1i_LHD_log_file
OUT_FILE4=L1i_LHD_log_file_perBlk
OUT_FILE5=L2_LHD_log_file
OUT_FILE6=L2_LHD_log_file_perBlk
OUT_EXT=.txt
NUM_CPU=--num-cpus=4
MEM_SIZE=--mem-size=4GB
############################################################
#perlbench.bzip.mcf.soplex
#NOTE: copy 'lib' and 'rules' folders in gem5 root
echo "perlbench.bzip.mcf.soplex Started"
sudo $GEM5_ROOT/build/ARM/gem5.opt --stats-file="$LOG_DATA_DIR/log_perlbench.bzip.mcf.soplex.txt" \
	$GEM5_ROOT/configs/deprecated/example/se.py $NUM_CPU $MAX_INST $FF $CPU_TYPE $CACHE $L2 \
	$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
	$MEM_SIZE \
	\-c "$BINARY_DIR/perlbench;$BINARY_DIR/bzip2;$BINARY_DIR/mcf;$BINARY_DIR/soplex" \
	--options="-I./lib $INPUT_DATA_DIR/perlbench/ref/input/checkspam.pl 2500 5 25 11 150 1 1 1 1;\
	$INPUT_DATA_DIR/bzip2/ref/input/control;\
	$INPUT_DATA_DIR/mcf/ref/input/inp.in;\
	-m3500 $INPUT_DATA_DIR/soplex/ref/input/ref.mps"
	
echo "perlbench.bzip.mcf.soplex Finished"
