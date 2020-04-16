#!/bin/bash
#
# Cronos Build Script V5
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
CR_VERSION=V12_Pro
CR_NAME=MinhKer_P
# Thread count
CR_JOBS=5
# Target android version and platform (7/n/8/o/9/p)
CR_ANDROID=p
CR_PLATFORM=9.0.0
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
CR_CONFG_A205=exynos7885-a20v1_P_defconfig
CR_VARIANT_A205=A205
CR_CONFG_A305=exynos7885-a30v2_defconfig
CR_VARIANT_A305=A305

# Script functions

read -p "Clean source (y/n) > " yn
if [ "$yn" = "Y" -o "$yn" = "y" ]; then
    echo "Clean Build"    
     make clean && make mrproper    
     rm -r -f $CR_DTB
     rm -rf $CR_DTS/.*.tmp
     rm -rf $CR_DTS/.*.cmd
     rm -rf $CR_DTS/*.dtb      
else
     echo "Dirty Build"
     rm -r -f $CR_DTB
     rm -rf $CR_DTS/.*.tmp
     rm -rf $CR_DTS/.*.cmd
     rm -rf $CR_DTS/*.dtb          
fi

BUILD_IMAGE_NAME()
{
	CR_IMAGE_NAME=$CR_NAME-$CR_VERSION-$CR_VARIANT-$CR_DATE

  # Flashable_script
  if [ $CR_VARIANT = $CR_VARIANT_A205 ]; then
    FL_VARIANT="A205X"
    FL_MODEL=a205X
  fi
  if [ $CR_VARIANT = $CR_VARIANT_A305 ]; then
    FL_VARIANT="A305X"
    FL_MODEL=a305X
  fi
}


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
	#echo "Building Boot.img for $CR_VARIANT"
	#cp -rf $CR_RAMDISK/* $CR_AIK
   	# cp -rf $CR_RAMDISK/* $CR_AIK
	cp $CR_KERNEL /home/m/share/KERNEL/MinhKer_kernel_P_a20_v14.4_pro/Image
	mv $CR_KERNEL $CR_AIK/split_img/boot.img-zImage
	#$CR_AIK/repackimg.sh
	# Remove red warning at boot
	#echo -n "SEANDROIDENFORCE" » $CR_AIK/image-new.img
	#echo "coping boot.img... to..."
	#cp $CR_AIK/image-new.img  /home/m/share/KERNEL/MINHKA_kernel_Q_a30_v14.3_pro/boot.img
	$CR_AIK/cleanup.sh
	#pass my ubuntu Lerov-vv
}
# Main Menu
clear
echo "----------------------------------------------"
echo "$CR_NAME $CR_VERSION Build Script"
echo "----------------------------------------------"
PS3='Please select your option (1-4): '
menuvar=("SM-A205" "SM-A305" "Build_all" "Exit")
select menuvar in "${menuvar[@]}"
do
    case $menuvar in
        "SM-A205")
            clear
            echo "Starting $CR_VARIANT_A205 kernel build..."
            CR_VARIANT=$CR_VARIANT_A205
            CR_CONFG=$CR_CONFG_A205
	    BUILD_ZIMAGE
           # PACK_BOOT_IMG
	    cp $CR_KERNEL /home/m/share/KERNEL/MinhKer_kernel_P_a20_v12_pro/Image
             echo "$CR_VARIANT kernel build and coppy finished."
	    break
            ;;
	"SM-A305")
             clear
            echo "Starting $CR_VARIANT_A305 kernel build..."
            CR_VARIANT=$CR_VARIANT_A305
            CR_CONFG=$CR_CONFG_A305
            BUILD_ZIMAGE
            #PACK_BOOT_IMG
	    cp $CR_KERNEL /home/m/share/KERNEL/MinhKer_kernel_P_a30_v12_pro/Image
            echo "$CR_VARIANT kernel build and coppy finished."
	    break
            ;;
	"Build_all")
            clear
            echo "Starting $CR_VARIANT_A205 kernel build..."
            CR_VARIANT=$CR_VARIANT_A205
            CR_CONFG=$CR_CONFG_A205
	    BUILD_ZIMAGE
           # PACK_BOOT_IMG
	    cp $CR_KERNEL /home/m/share/KERNEL/MinhKer_kernel_P_a20_v12_pro/Image
            echo "$CR_VARIANT kernel build and coppy finished."
	    clear
            echo "Starting $CR_VARIANT_A305 kernel build..."
            CR_VARIANT=$CR_VARIANT_A305
            CR_CONFG=$CR_CONFG_A305
            BUILD_ZIMAGE
            #PACK_BOOT_IMG
	    cp $CR_KERNEL /home/m/share/KERNEL/MinhKer_kernel_P_a30_v12_pro/Image
            echo "$CR_VARIANT kernel build and coppy finished."
	    break
            ;;
        "Exit")
            break
            ;;
        *) echo Invalid option.;;
    esac
done

