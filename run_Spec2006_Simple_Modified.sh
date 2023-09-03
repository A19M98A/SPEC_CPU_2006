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
# DibugFlags="None"

CACHE=--caches
L2=--l2cache
L2_SIZE="--l2A_size=256kB --l2B_size=256kB --l2C_size=256kB --l2D_size=256kB"
L2_ASSOC="--l2A_assoc=16 --l2B_assoc=16 --l2C_assoc=16 --l2D_assoc=16"

L1D_SIZE=--l1d_size=32kB
L1D_ASSOC=--l1d_assoc=4

L1I_SIZE=--l1i_size=32kB
L1I_ASSOC=--l1i_assoc=4

LINE_SIZE=--cacheline_size=256

CPU_Type=--cpu-type=TimingSimpleCPU

LOG_DATA_DIR=/home/amin/Documents/Storage/gem5/logs
INPUT_DATA_DIR=/home/amin/Documents/Storage/cpu2006/data
BINARY_DIR=/home/amin/Documents/Storage/cpu2006/binaries
GEM5_ROOT=/home/amin/Documents/Storage/gem5

MAX_INST=--maxinsts=1000000000

FF=--fast-forward=0

OUT_FILE1=L1d_LHD_log_file
OUT_FILE2=L1d_LHD_log_file_perBlk
OUT_FILE3=L1i_LHD_log_file
OUT_FILE4=L1i_LHD_log_file_perBlk
OUT_FILE5=L2_LHD_log_file
OUT_FILE6=L2_LHD_log_file_perBlk
OUT_EXT=.txt

tm="$(date +%s)"
RED='\033[0;31m'
GREN='\033[0;32m'
YELLOW='\033[1;33m'
Cyan='\033[0;36m'
NC='\033[0m'

rm -rf $LOG_DATA_DIR/*

progress () {
	start=$SECONDS
	i=1
	sp="/-\|"
	echo -n ' '
	while true
	do
		duration=$(( SECONDS - start ))
		sec=$((duration%60))
		if [ $sec -gt 9 ]
		then
			sec=$sec
		else
			sec=0$sec
		fi
		min=$((duration/60%60))
		if [ $min -gt 9 ]
		then
			min=$min
		else
			min=0$min
		fi
		hor=$((duration/60/60))
		if [ $hor -gt 9 ]
		then
			hor=$hor
		else
			hor=0$hor
		fi
		echo -ne "\r${sp:i++%${#sp}:1} ${hor}:${min}:${sec}"
		sleep 0.3
	done
}

echo " -----------"
echo -e "|  By ${RED}AM.A${NC}  |"
echo " -----------"

runProgran () {
	progress&
	{
		extra=''
		if [ $# -gt 3 ]
		then
			echo $4
			extra="$INPUT_DATA_DIR/$4"
		fi
		sudo $GEM5_ROOT/build/ARM/gem5.opt --debug-flags=$DibugFlags --stats-file="$LOG_DATA_DIR/$1" \
		$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
		$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
		\-c $BINARY_DIR/$2 \
		--options="$INPUT_DATA_DIR/$3 $extra"

	} &> $LOG_DATA_DIR/output.$1
	kill $(jobs -p)
	echo ""
}

# cpu2006
# ###########################################################
# 403.gcc
echo -e "3.403.${YELLOW}gcc ${Cyan}Started${NC}"
runProgran log_403.gcc.txt gcc gcc/ref/input/200.in
echo -e "3.403.${YELLOW}gcc ${GREN}Finished${NC}"
# ############################################################
# #400.perlbench
# #NOTE: copy 'lib' and 'rules' folders in gem5 root
# echo -e "1.400.${YELLOW}perlbench ${Cyan}Started${NC}"
# progress&
# {
# 	$GEM5_ROOT/build/ARM/gem5.opt --debug-flags=$DibugFlags --stats-file="$LOG_DATA_DIR/log_400.perlbench.txt" \
# 		$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 		$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 		-c $BINARY_DIR/perlbench \
# 		--options="-I $INPUT_DATA_DIR/perlbench/all/input/lib $INPUT_DATA_DIR/perlbench/ref/input/checkspam.pl 2500 5 25 11 150 1 1 1 1 "
# } &> $LOG_DATA_DIR/output.1.400.perlbench.txt
# kill $(jobs -p)
# echo ""
# echo -e "1.400.${YELLOW}perlbench ${GREN}Finished${NC}"
# ############################################################
# # #401.bzip2
# echo -e "2.401.${YELLOW}bzip2 ${Cyan}Started${NC}"
# progress&
# {
# 	$GEM5_ROOT/build/ARM/gem5.opt --debug-flags=$DibugFlags --stats-file="$LOG_DATA_DIR/log_401.bzip2.txt" \
# 		$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 		$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 		\-c $BINARY_DIR/bzip2 \
# 		--options="$INPUT_DATA_DIR/bzip2/ref/input/control"

# } &> $LOG_DATA_DIR/output.1.400.perlbench.txt
# kill $(jobs -p)
# echo ""
# echo -e "2.401.${YELLOW}bzip2 ${GREN}Finished${NC}"
# # ############################################################
# # #410.bwaves
# echo -e "4.410.${YELLOW}bwaves ${Cyan}Started${NC}"
# progress&
# {
# 	$GEM5_ROOT/build/ARM/gem5.opt --debug-flags=$DibugFlags --stats-file="$LOG_DATA_DIR/log_410.bwaves.txt" \
# 		$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 		$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 		--mem-size=2GB \-c $BINARY_DIR/bwaves \
# 		--options="$INPUT_DATA_DIR/bwaves/ref/input/bwaves.in"
# } &> $LOG_DATA_DIR/output.4.410.bwaves.txt
# kill $(jobs -p)
# echo ""
# echo -e "4.410.${YELLOW}bwaves ${GREN}Finished${NC}"
# # ##############################################################
# # #429.mcf
# echo -e "5.429.${YELLOW}mcf ${Cyan}Started${NC}"
# progress&
# {
# 	$GEM5_ROOT/build/ARM/gem5.opt --debug-flags=$DibugFlags --stats-file="$LOG_DATA_DIR/log_429.mcf.txt" \
# 		$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 		$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 		--mem-size=2GB \-c $BINARY_DIR/mcf \
# 		--options="$INPUT_DATA_DIR/mcf/ref/input/inp.in"
# } &> $LOG_DATA_DIR/output.5.429.mcf.txt
# kill $(jobs -p)
# echo ""
# echo -e "5.429.${YELLOW}mcf ${GREN}Finished${NC}"
# # ############################################################
# # #436.cactusADM
# echo -e "6.436.${YELLOW}cactusADM ${Cyan}Started${NC}"
# progress&
# {
# 	$GEM5_ROOT/build/ARM/gem5.opt --debug-flags=$DibugFlags --stats-file="$LOG_DATA_DIR/log_436.cactusADM.txt" \
# 		$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 		$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 		--mem-size=2GB \-c $BINARY_DIR/cactusADM \
# 		--options="$INPUT_DATA_DIR/cactusADM/ref/input/benchADM.par"
# } &> $LOG_DATA_DIR/output.6.436.cactusADM.txt
# kill $(jobs -p)
# echo ""
# echo -e "6.436.${YELLOW}cactusADM ${GREN}Finished${NC}"
# # ############################################################
# # #444.namd
# echo -e "7.444.${YELLOW}namd ${Cyan}Started${NC}"
# progress&
# {
# 	$GEM5_ROOT/build/ARM/gem5.opt --debug-flags=$DibugFlags --stats-file="$LOG_DATA_DIR/log_444.namd.txt" \
# 		$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 		$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 		\-c $BINARY_DIR/namd \
# 		--options="--input $INPUT_DATA_DIR/namd/all/input/namd.input \
# 		--iterations 38 --output namd.out"
# } &> $LOG_DATA_DIR/output.7.444.namd.txt
# kill $(jobs -p)
# echo ""
# echo -e "7.444.${YELLOW}namd ${GREN}Finished${NC}"
# ############################################################
# #447.dealII
# echo "8.447.dealII Started"
# $GEM5_ROOT/build/ARM/gem5.opt --stats="$LOG_DATA_DIR/log_447.dealII.txt" \
# 	$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 	$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 	\-c $BINARY_DIR/dealII 
# 	#--options="$INPUT_DATA_DIR/dealII/ref/input/"
# 	#no input file needs

# echo "8.447.dealII Finished"
# ############################################################
# #450.soplex
# echo "9.450.soplex Started"
# $GEM5_ROOT/build/ARM/gem5.opt --stats="$LOG_DATA_DIR/log_450.soplex.txt" \
# 	$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type \
# 	$FF $MAX_INST $CACHE $L2 \
# 	$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 	\-c $BINARY_DIR/soplex \
# 	--options="-m3500 $INPUT_DATA_DIR/soplex/ref/input/ref.mps"

# echo "9.450.soplex Finished"
# ############################################################
# #454.calculix
# echo "10.454.calculix Started"
# $GEM5_ROOT/build/ARM/gem5.opt --stats="$LOG_DATA_DIR/log_454.calculix.txt" \
# 	$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 	$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 	\-c $BINARY_DIR/calculix \
# 	--options="$INPUT_DATA_DIR/calculix/ref/input/hyperviscoplastic"
# 	#NOTE: for 'hyperviscoplastic.inp' file you should not the postfix

# echo "10.454.calculix Finished"
# ############################################################
# #456.hmmer
# echo "11.456.hmmer Started"
# $GEM5_ROOT/build/ARM/gem5.opt --stats="$LOG_DATA_DIR/log_456.hmmer.txt" \
# 	$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 	$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 	\-c $BINARY_DIR/hmmer \
# 	--options="--fixed 0 --mean 500 --num 500000 --sd 350 --seed 0 \
# 	$INPUT_DATA_DIR/hmmer/ref/input/nph3.hmm"

# echo "11.456.hmmer Finished"
# ############################################################
# #458.sjeng
# echo "12.458.sjeng Started"
# $GEM5_ROOT/build/ARM/gem5.opt --stats="$LOG_DATA_DIR/log_458.sjeng.txt" \
# 	$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 	$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 	\-c $BINARY_DIR/sjeng \
# 	--options="$INPUT_DATA_DIR/sjeng/ref/input/ref.txt"

# echo "12.458.sjeng Finished"
# ############################################################
# #462.libquantum
# echo "13.462.libquantum Started"
# $GEM5_ROOT/build/ARM/gem5.opt --stats="$LOG_DATA_DIR/log_462.libquantum.txt" \
# 	$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 	$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 	\-c $BINARY_DIR/libquantum \
# 	--options="1397 8"
# 	#--options="$INPUT_DATA_DIR/libquantum/ref/input/control"
# 	#NOTE: we used the contents of 'control' file

# echo "13.462.libquantum Finished"
# ############################################################
# #464.h264ref
# #NOTE: copy 'sss.yuv' into gem5 root. 
# echo "14.464.h264ref Started"
# $GEM5_ROOT/build/ARM/gem5.opt --stats="$LOG_DATA_DIR/log_464.h264ref.txt" \
# 	$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 	$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 	\-c $BINARY_DIR/h264ref \
# 	--options="-d $INPUT_DATA_DIR/h264ref/ref/input/sss_encoder_main.cfg"

# echo "14.464.h264ref Finished"
# ############################################################
# #470.lbm
# echo "15.470.lbm Started"
# $GEM5_ROOT/build/ARM/gem5.opt --stats="$LOG_DATA_DIR/log_470.lbm.txt" \
# 	$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 	$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 	\-c $BINARY_DIR/lbm \
# 	--options="3000 lbm_reference.dat 0 0 $INPUT_DATA_DIR/lbm/ref/input/100_100_130_ldc.of"
# 	#option is the content of 'lbm.in file'

# echo "15.470.lbm Finished"
# ############################################################
# #471.omnetpp
# echo "16.471.omnetpp Started"
# #NOTE: copy 'omnetpp.ini' in root directory
# $GEM5_ROOT/build/ARM/gem5.opt --stats="$LOG_DATA_DIR/log_471.omnetpp.txt" \
# 	$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 	$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 	\-c $BINARY_DIR/omnetpp \
# 	#--options="$INPUT_DATA_DIR/omnetpp/ref/input/omnetpp.ini"
# 	#no need for option. just copy input in root

# echo "16.471.omnetpp Finished"
# ############################################################
# #473.astar
# echo "17.473.astar Started"
# $GEM5_ROOT/build/ARM/gem5.opt --stats="$LOG_DATA_DIR/log_473.astar.txt" \
# 	$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 	$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 	\-c $BINARY_DIR/astar \
# 	--options="$INPUT_DATA_DIR/astar/ref/input/BigLakes2048.cfg"

# echo "17.473.astar Finished"
# ############################################################
# #483.xalancbmk
# echo "18.483.xalancbmk Started"
# $GEM5_ROOT/build/ARM/gem5.opt --stats="$LOG_DATA_DIR/log_483.xalancbmk.txt" \
# 	$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 	$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 	\-c $BINARY_DIR/xalancbmk \
# 	--options="-v $INPUT_DATA_DIR/xalancbmk/ref/input/t5.xml \
# 				$INPUT_DATA_DIR/xalancbmk/ref/input/xalanc.xsl"

# echo "18.483.xalancbmk Finished"

# # Added benchmarks by A.M.H.M
# ############################################################
# #998.specrand
# echo "19.998.specrand Started"
# $GEM5_ROOT/build/ARM/gem5.opt --stats="$LOG_DATA_DIR/log_998.specrand.txt" \
# 	$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 	$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 	--mem-size=2GB \-c $BINARY_DIR/specrand \
# 	--option="324342 24239"

# echo "19.998.specrand Finished"
# ############################################################
# #453.povray
# echo "20.453.povray Started"
# $GEM5_ROOT/build/ARM/gem5.opt --stats="$LOG_DATA_DIR/log_453.povray.txt" \
# 	$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 	$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 	\-c $BINARY_DIR/povray \
# 	--option="$INPUT_DATA_DIR/povray/SPEC-benchmark-test.ini"

# echo "20.453.povray Finished"
# ############################################################
# #445.gobmk
# #NOTE: copy 'lib' and 'rules' folders in gem5 root
# echo "21.445.gobmk Started"
# $GEM5_ROOT/build/ARM/gem5.opt --stats="$LOG_DATA_DIR/log_445.gobmk.txt" \
# 	$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 	$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 	\-c $BINARY_DIR/gobmk \
# 	--option="$INPUT_DATA_DIR/gobmk/capture.tst"

# echo "21.445.gobmk Finished"
# ############################################################
# #433.milc
# echo "22.433.milc Started"
# $GEM5_ROOT/build/ARM/gem5.opt --stats="$LOG_DATA_DIR/log_433.milc.txt" \
# 	$GEM5_ROOT/configs/deprecated/example/se.py $CPU_Type $FF $MAX_INST $CACHE $L2 \
# 	$L1D_SIZE $L1I_SIZE $L1I_ASSOC $L1D_ASSOC $LINE_SIZE $L2_SIZE \
# 	\-c $BINARY_DIR/milc \
# 	--input="$INPUT_DATA_DIR/milc/su3imp.in"

# echo "22.433.milc Finished"
# ############################################################

# echo "All Simulation Run Was Finished for All Configurations"
# tm="$(($(date +%s)-tm))"
# tm="$((tm/60))"
# echo "Time in minutes: ${tm}"