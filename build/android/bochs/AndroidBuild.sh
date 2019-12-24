#!/bin/sh

LOCAL_PATH=`dirname $0`
LOCAL_PATH=`cd $LOCAL_PATH && pwd`

export PATH=$LOCAL_PATH/..:$PATH # For our custom sdl-config
ANDROIDSDL=../../../../androidsdl

if [ \! -f bochs/configure ] ; then
	sh -c "cd bochs && ./bootstrap.sh"
fi

mkdir -p bin-$1

if [ \! -f bin-$1/Makefile ] ; then
        env CLANG=1

  if [ "$1" = arm64-v8a ]; then
	env CFLAGS="-O2 -ffast-math" \
    env CLANG=1 \
		$ANDROIDSDL/project/jni/application/setEnvironment-$1.sh sh -c "cd bin-$1 && ../bochs/configure \
		--build=x86_64-unknown-linux-gnu --host=$2 --with-sdl \
		--enable-cpu-level=6 --enable-smp --enable-3dnow --enable-x86-64 --enable-vmx=2 --enable-avx --enable-evex \
		--enable-sb16 --enable-es1370 \
		--enable-ne2000 --enable-pnic --enable-e1000 \
		--enable-clgd54xx --enable-voodoo \
		--enable-all-optimizations \
		--enable-usb --enable-usb-ohci --enable-usb-ehci --enable-usb-xhci \
		--enable-busmouse \
		--disable-gameport --disable-disasm --disable-docbook" || exit 1
  else
	env CFLAGS="-Ofast -Wno-narrowing -DANDROID" \
    env CLANG=1 \
		$ANDROIDSDL/project/jni/application/setEnvironment-$1.sh sh -c "cd bin-$1 && ../bochs/configure \
		--build=x86_64-unknown-linux-gnu --host=$2 --with-sdl \
		--enable-cpu-level=6 --enable-smp --enable-3dnow --enable-x86-64 --enable-vmx=2 --enable-avx --enable-evex \
		--enable-sb16 --enable-es1370 \
		--enable-ne2000 --enable-pnic --enable-e1000 \
		--enable-clgd54xx --enable-voodoo \
		--enable-all-optimizations \
		--enable-usb --enable-usb-ohci --enable-usb-ehci --enable-usb-xhci \
		--enable-busmouse \
		--disable-gameport --disable-disasm --disable-docbook" || exit 1
  fi
fi


# Fix a compilation error
#mkdir -p bin-$1/iodev/network/slirp
#mkdir -p bin-$1/cpu/decoder


make -j4 -C bin-$1 && mv -f bin-$1/bochs libapplication-$1.so
