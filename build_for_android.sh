#!/bin/sh
#设置临时目录，不是必须的，不设置的话，会自己在系统的temp目录下生成一个, 设置的话，需要在ffmpeg的根目录下创建一个ffmpegtemp文件夹
export TMPDIR=/Users/zhangqing/Downloads/FFmpeg-n4.1.4/ffmpegtemp

#设置ndk目录
NDK=/Users/zhangqing/Library/Android/sdk/ndk-bundle

#ar nm 的prefix
PLATFORM=arm-linux-androideabi

#llvm toolchain路径
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64

#sysroot 这个一定要设置成 ndk的llvm 路径下的 sysroot 
SYSROOT=$TOOLCHAIN/sysroot

#ASM 路径， 同上必须是llvm 目录下的 asm
ASM=$SYSROOT/usr/include/$PLATFORM

#完整的 cross prefix
CROSS_PREFIX=$TOOLCHAIN/bin/$PLATFORM-

#专门给ndk clang/clang++ 的 cross prefix
ANDROID_CROSS_PREFIX=$TOOLCHAIN/bin/armv7a-linux-androideabi29-

function build_one
{
  ./configure \
    --prefix=$PREFIX \
    --enable-shared \
    --enable-static \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-avdevice \
    --disable-doc \
    --disable-symver \
    --cross-prefix=$CROSS_PREFIX \
    --cc=${ANDROID_CROSS_PREFIX}clang     --target-os=android \
    --arch=arm \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --extra-cflags="-I$ASM -isysroot $SYSROOT -Os -fpic" \

  $ADDITIONAL_CONFIGURE_FLAG

  make clean
  make -j8
  make install
}

# arm v7vfp
CPU=armv7-a
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "
PREFIX=./android/$CPU-vfp
ADDITIONAL_CONFIGURE_FLAG=
build_one
