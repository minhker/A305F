#!/bin/bash
#
# Cronos Build Script V3.0
# For Exynos7870
# edit for exynos7904 by Minhker
# Coded by BlackMesa/AnanJaser1211 @2019
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software

# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Main Dir
CR_DIR=$(pwd)
# Define toolchan path
CR_TC=/home/m/kernel/aarch64-linux-android-4.9/bin/aarch64-linux-android-
# Presistant A.I.K Location
CR_AIK=$CR_DIR/mk/A.I.K
# Main Ramdisk Location
CR_RAMDISK=$CR_DIR/mk/Ramdisk
# Compiled image name and location (Image/zImage)
CR_KERNEL=$CR_DIR/arch/arm64/boot/Image
# Kernel Name and Version
CR_VERSION=V14
CR_NAME=MinhKer_Q
# Thread count
CR_JOBS=5
# Target android version and platform (7/n/8/o/9/p)
CR_ANDROID=q
CR_PLATFORM=10.0
# Target ARCH
CR_ARCH=arm64
# Current Date
CR_DATE=$(date +%Y%m%d)
# Init build
export CROSS_COMPILE=$CR_TC
# General init
export ANDROID_MAJOR_VERSION=$CR_ANDROID
export PLATFORM_VERSION=$CR_PLATFORM
export $CR_ARCH
##########################################
CR_CONFG_A305F=exynos7885-a30v2_Q_defconfig
CR_VARIANT_A305F=A305F

#Script functions

read -p "Clean source (y/n) > " yn
if [ "$yn" = "Y" -o "$yn" = "y" ]; then
     echo "Clean Build"    
     make clean && make mrproper  
     rm -rf $CR_DTS/.*.tmp
     rm -rf $CR_DTS/.*.cmd
     rm -rf $CR_DTS/*.dtb      
else
     echo "Dirty Build"
     rm -rf $CR_DTS/.*.tmp
     rm -rf $CR_DTS/.*.cmd
     rm -rf $CR_DTS/*.dtb          
fi

BUILD_ZIMAGE()
{
	echo "Building zImage for $CR_VARIANT"
	export LOCALVERSION=-$CR_NAME-$CR_VERSION-$CR_VARIANT-$CR_DATE
	make  $CR_CONFG
	make -j$CR_JOBS
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
	echo "Building Boot.img for $CR_VARIANT"
	cp -rf $CR_RAMDISK/* $CR_AIK
   	 cp -rf $CR_RAMDISK/* $CR_AIK
	mv $CR_KERNEL $CR_AIK/split_img/boot.img-zImage
	$CR_AIK/repackimg.sh
	# Remove red warning at boot
	echo -n "SEANDROIDENFORCE" » $CR_AIK/image-new.img
	echo "coping boot.img... to..."
	cp $CR_AIK/image-new.img  /home/m/share/KERNEL/MINHKA_kernel_Q_a305fv14/boot.img
	$CR_AIK/cleanup.sh
	#pass my ubuntu Lerov-vv
}
# Main Menu
clear
echo "----------------------------------------------"
echo "$CR_NAME $CR_VERSION Build Script"
echo "----------------------------------------------"

            clear
            echo "Starting $CR_VARIANT_A305F kernel build..."
            CR_VARIANT=$CR_VARIANT_A305F
            CR_CONFG=$CR_CONFG_A305F
            BUILD_ZIMAGE
            PACK_BOOT_IMG
            echo "$CR_VARIANT kernel build finished."

