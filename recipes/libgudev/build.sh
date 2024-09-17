./configure --build=$BUILD --host=$HOST --prefix $PREFIX --disable-umockdev
make -j${CPU_COUNT} install
