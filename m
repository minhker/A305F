#!/bin/bash
#
# by Minhker
# MK Build Script V7

# Main Dir
MK_DIR=$(pwd)

MK_TC=/home/m/kernel/aarch64-linux-android-4.9/bin/aarch64-linux-android-
MK_CLANG_TRIPLE=/home/m/kernel/toolchain/clang/host/linux-x86/clang-4639204/bin/aarch64-linux-gnu-
Mk_CC=/home/m/kernel/toolchain/clang/host/linux-x86/clang-4639204/bin/clang
#CCACHE := ccache
#Mk_AS= $(CCACHE) $(CROSS_COMPILE)as
#Mk_LD= $(CCACHE) $(CROSS_COMPILE)ld
#Mk_CC=$(CCACHE)/home/m/kernel/toolchain/clang/host/linux-x86/clang-4639204/bin/clang
#Mk_CPP= $(CCACHE) $(CC) -E
#Mk_AR= $(CCACHE) $(CROSS_COMPILE)ar
#Mk_NM= $(CCACHE) $(CROSS_COMPILE)nm
#Mk_STRIP= $(CCACHE) $(CROSS_COMPILE)strip
#Mk_OBJCOPY= $(CCACHE) $(CROSS_COMPILE)objcopy
#Mk_OBJDUMP= $(CCACHE) $(CROSS_COMPILE)objdump

MK_KERNEL=$MK_DIR/arch/arm64/boot/Image
MK_DTBO=$MK_DIR/arch/arm64/boot/dtbo.img
# Kernel Name and Version
MK_VERSION=V14.8_Pro
MK_NAME=MinhKer_Q
# Thread count
MK_JOBS=5
# Target android version and platform (7/n/8/o/9/p)
MK_ANDROID=q
MK_PLATFORM=10.0
# Target ARCH
MK_ARCH=arm64
# Current Date
MK_DATE=$(date +%Y%m%d)
# Init build
export CROSS_COMPILE=$MK_TC
export CLANG_TRIPLE=$MK_CLANG_TRIPLE
export CC=$Mk_CC
#export AS=$Mk_AS
#export LD=$Mk_LD
#export CPP=$Mk_CPP
#export AR=$Mk_AR
#export NM=$Mk_NM
#export STRIP=$Mk_STRIP
#export OBJCOPY=$Mk_OBJCOPY
#export OBJCOPY=$Mk_OBJCOPY
#export CC=$Mk_CC

# General init
export ANDROID_MAJOR_VERSION=$MK_ANDROID
export PLATFORM_VERSION=$MK_PLATFORM
export ARCH=$MK_ARCH
##########################################

MK_CONFG_A30S=exynos7885-a30s_Q_defconfig
MK_VARIANT_A30S=A307
MK_CONFG_M30S=m30sdd_defconfig
MK_VARIANT_M30S=M307F
MK_CONFG_A305=exynos7885-a30v2_Q_defconfig
MK_VARIANT_A305=A305
MK_CONFG_A205=exynos7885-a20v2_Q_defconfig
MK_VARIANT_A205=A205
MK_CONFG_A405=exynos7885-a40v2_Q_defconfig
MK_VARIANT_A405=A405
MK_CONFG_M205=exynos7885-m20v2_Q_defconfig
MK_VARIANT_M205=M205
MK_CONFG_M305=exynos7885-m30v2_Q_defconfig
MK_VARIANT_M305=M305
MK_CONFG_A105=a10_00_defconfig
MK_VARIANT_A105=A105
MK_CONFG_T510=halium-gta3xlwifi_defconfig
MK_VARIANT_T510=T510
# Script functions

read -p "Clean source (y/n) > " yn
if [ "$yn" = "Y" -o "$yn" = "y" ]; then
     echo "Clean Build"    
     make clean     
else
     echo "okey will build kernel"         
fi

BUILD_ZIMAGE()
{
	echo "Building zImage for $MK_VARIANT"
	export LOCALVERSION=-$MK_NAME-$MK_VERSION-$MK_VARIANT-$MK_DATE
	make  $MK_CONFG
	make -j$MK_JOBS
	if [ ! -e ./arch/arm64/boot/Image ]; then
	exit 0;
	echo "zImage Failed to Compile"
	echo " Abort "
	fi
	echo " "
	echo "----------------------------------------------"
}
PACK_BOOT_IMG()
{
	echo "----------------------------------------------"
	echo " "
	echo "Building Boot.img for $MK_VARIANT"
	cp -rf $MK_RAMDISK/* $MK_AIK
   	 cp -rf $MK_RAMDISK/* $MK_AIK
	cp $MK_KERNEL /home/m/share/KERNEL/MinhKer_kernel_Q_a30_v14.4_pro/Image
	mv $MK_KERNEL $MK_AIK/split_img/boot.img-zImage
	$MK_AIK/repackimg.sh
	# Remove red warning at boot
	echo -n "SEANDROIDENFORCE" » $MK_AIK/image-new.img
	echo "coping boot.img... to..."
	#cp $MK_AIK/image-new.img  /home/m/share/KERNEL/MINHKA_kernel_Q_a30_v14.3_pro/boot.img
	$MK_AIK/cleanup.sh
	#pass my ubuntu Lerov-vv
}
# Main Menu
clear
echo "----------------------------------------------"
echo "$MK_NAME $MK_VERSION Build Script"
echo "----------------------------------------------"
PS3='Please select your option (1-x): '
menuvar=("SM-A30S" "SM-M30S" "SM-A205" "SM-M305" "SM-A305" "SM-M205" "SM-A405" "SM-A105" "SM-T510" "build_all" "Exit")
select menuvar in "${menuvar[@]}"
do
    case $menuvar in
       	"SM-M30S")
            clear
            echo "Starting $MK_VARIANT_M30S kernel build..."
            MK_VARIANT=$MK_VARIANT_M30S
            MK_CONFG=$MK_CONFG_M30S
	    BUILD_ZIMAGE
	    break
            ;;
	"SM-A30S")
            clear
            echo "Starting $MK_VARIANT_A30S kernel build..."
            MK_VARIANT=$MK_VARIANT_A30S
            MK_CONFG=$MK_CONFG_A30S
	    BUILD_ZIMAGE
	    cp $MK_KERNEL /home/m/share/KERNEL/MinhKer_kernel_Q_A30S_v14.7_pro/Image
	    break
            ;;
 "SM-A205")
            clear
            echo "Starting $MK_VARIANT_A205 kernel build..."
            MK_VARIANT=$MK_VARIANT_A205
            MK_CONFG=$MK_CONFG_A205
	    BUILD_ZIMAGE
	    cp $MK_KERNEL /home/m/share/KERNEL/MinhKer_kernel_Q_a20_v14.7_pro/Image
echo "$MK_VARIANT kernel build and coppy finished."
	    break
            ;;
	"SM-M205")
            clear
            echo "Starting $MK_VARIANT_M205 kernel build..."
            MK_VARIANT=$MK_VARIANT_M205
            MK_CONFG=$MK_CONFG_M205
	    BUILD_ZIMAGE
	    cp $MK_KERNEL /home/m/share/KERNEL/MinhKer_kernel_Q_m20_v14.6_pro/Image
echo "$MK_VARIANT kernel build and coppy finished."
	    break
            ;;
            "SM-M305")
            clear
            echo "Starting $MK_VARIANT_M305 kernel build..."
            MK_VARIANT=$MK_VARIANT_M305
            MK_CONFG=$MK_CONFG_M305
	    BUILD_ZIMAGE
	    cp $MK_KERNEL /home/m/share/KERNEL/MinhKer_kernel_Q_m30_v14.5_little/Image
	    break
            ;;
	"SM-A405")
            clear
            echo "Starting $MK_VARIANT_A405 kernel build..."
            MK_VARIANT=$MK_VARIANT_A405
            MK_CONFG=$MK_CONFG_A405
	    BUILD_ZIMAGE
	    cp $MK_KERNEL /home/m/share/KERNEL/MinhKer_kernel_Q_a40_v14.7_pro/Image
	    break
            ;;
"SM-A105")
            clear
            echo "Starting $MK_VARIANT_A105 kernel build..."
            MK_VARIANT=$MK_VARIANT_A105
            MK_CONFG=$MK_CONFG_A105
	    BUILD_ZIMAGE
	    cp $MK_KERNEL /home/m/share/KERNEL/MinhKer_kernel_Q_a10_v14.7_pro/Image
	    break
            ;;
"SM-T510")
            clear
            echo "Starting $MK_VARIANT_T510 kernel build..."
            MK_VARIANT=$MK_VARIANT_T510
            MK_CONFG=$MK_CONFG_T510
	    BUILD_ZIMAGE
	    cp $MK_KERNEL /home/m/share/KERNEL/MinhKer_kernel_Q_T510_v14.6_pro/Image
	    break
            ;;
	"SM-A305")
             clear
            echo "Starting $MK_VARIANT_A305 kernel build..."
            MK_VARIANT=$MK_VARIANT_A305
            MK_CONFG=$MK_CONFG_A305
            BUILD_ZIMAGE
	    cp $MK_KERNEL /home/m/share/KERNEL/MinhKer_kernel_Q_a30_v14.8_Pro/Image
	    cp $MK_DTBO /home/m/share/KERNEL/MinhKer_kernel_Q_a30_v14.8_Pro/dtbo.img
		cp /arch/arm64/boot/dts/exynos/dtbo/exynos7885.dtb /home/m/kernel/try_build_dtb_dtbo/exynos7885.dtb
		echo "$MK_VARIANT kernel build and coppy finished."
	    break
            ;;
	"build_all")
            clear
            echo "Starting $MK_VARIANT_A205 kernel build..."
            MK_VARIANT=$MK_VARIANT_A205
            MK_CONFG=$MK_CONFG_A205
	    BUILD_ZIMAGE
	    cp $MK_KERNEL /home/m/share/KERNEL/MinhKer_kernel_Q_a20_v14.7_pro/Image
             clear
            echo "Starting $MK_VARIANT_A305 kernel build..."
            MK_VARIANT=$MK_VARIANT_A305
            MK_CONFG=$MK_CONFG_A305
            BUILD_ZIMAGE
	    cp $MK_KERNEL /home/m/share/KERNEL/MinhKer_kernel_Q_a30_v14.7_Pro/Image
echo "$MK_VARIANT kernel build and coppy finished."
clear
            echo "Starting $MK_VARIANT_A405 kernel build..."
            MK_VARIANT=$MK_VARIANT_A405
            MK_CONFG=$MK_CONFG_A405
	    BUILD_ZIMAGE
	    cp $MK_KERNEL /home/m/share/KERNEL/MinhKer_kernel_Q_a40_v14.7_pro/Image
clear
            echo "Starting $MK_VARIANT_A105 kernel build..."
            MK_VARIANT=$MK_VARIANT_A105
            MK_CONFG=$MK_CONFG_A105
	    BUILD_ZIMAGE
	    cp $MK_KERNEL /home/m/share/KERNEL/MinhKer_kernel_Q_a10_v14.7_pro/Image
	    break
clear
            echo "Starting $MK_VARIANT_A30S kernel build..."
            MK_VARIANT=$MK_VARIANT_A30S
            MK_CONFG=$MK_CONFG_A30S
	    BUILD_ZIMAGE
	    cp $MK_KERNEL /home/m/share/KERNEL/MinhKer_kernel_Q_A30S_v14.7_pro/Image
 ;;
        "Exit")
            break
            ;;
        *) echo Invalid option.;;
	          
    esac
done
