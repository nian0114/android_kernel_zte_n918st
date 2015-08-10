#!/bin/sh
export KERNELDIR=`readlink -f .`

export ARCH=arm
export CROSS_COMPILE=../arm-eabi-4.7/bin/arm-eabi-

export CONFIG_BUILD_ARM_APPENDED_DTB_IMAGE_NAMES_ZTEMT=qcom/msm8916-mtp-N918X
export BUILD_LOCALVERSION="N918St-Nian-Release"

if [ ! -f ../arm-eabi-4.7/bin/arm-eabi-addr2line ];
then
  cd ../ 
  git clone git://aosp.tuna.tsinghua.edu.cn/android/platform/prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/
  cd $KERNELDIR
fi

ln -s $KERNELDIR/drivers/video/msm/mdss/mdss_mdp.h $KERNELDIR/include/mdss_mdp.h
ln -s $KERNELDIR/drivers/video/msm/mdss/mmdss_mdp_trace.h $KERNELDIR/include/mdss_mdp_trace.h

if [ ! -f $KERNELDIR/.config ];
then
  make defconfig msm8916-N918X-perf_defconfig
fi

. $KERNELDIR/.config

cd $KERNELDIR/
mv .git .git-halt
make -j4

mkdir -p $KERNELDIR/BUILT_N918X/lib/modules

rm $KERNELDIR/BUILT_N918X/lib/modules/*
rm $KERNELDIR/BUILT_N918X/zImage

find -name '*.ko' -exec cp -av {} $KERNELDIR/BUILT_N918X/lib/modules/ \;
${CROSS_COMPILE}strip --strip-unneeded $KERNELDIR/BUILT_N918X/lib/modules/*
cp $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/BUILT_N918X/

mv .git-halt .git
