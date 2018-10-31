#!/bin/bash

# Dockerfile for GDAL - Geospatial Data Abstraction Library 

# Exit on any non-zero status.
trap 'exit' ERR
set -E

echo "Compiling GDAL ${GDAL_VERSION}..."

01-install.sh

# out : giflib-dev, libpng-dev, tiff-dev
# removing java support (none of the solutions found worked)
# /usr/lib/gcc/x86_64-alpine-linux-musl/6.4.0/../../../../x86_64-alpine-linux-musl/bin/ld: warning: libjvm.so, needed by /tmp/gdal-2.3.2/.libs/libgdal.so, not found (try using -rpath or -rpath-link)
# /tmp/gdal-2.3.2/.libs/libgdal.so: undefined reference to `JNI_CreateJavaVM@SUNWprivate_1.1'
# /tmp/gdal-2.3.2/.libs/libgdal.so: undefined reference to `JNI_GetCreatedJavaVMs@SUNWprivate_1.1'
# collect2: error: ld returned 1 exit status
#    openjdk8 \

apk add --update \
    bash-completion \
    boost \
    boost-regex \
    boost-system \
    boost-thread \
    boost-dev \
    curl-dev \
    flex-dev \
    gettext-dev \
    groff \
    jpeg \
    jpeg-dev \
    json-c \
    json-c-dev \
    lcms2 \
    lcms2-dev \
    libffi \
    libffi-dev \
    libintl \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    libtirpc \
    libtirpc-dev \
    libwebp \
    libwebp-dev \
    libxml2 \
    libxml2-dev \
    mariadb-connector-c \
    mariadb-connector-c-dev \
    mariadb-embedded \
    mariadb-embedded-dev \
    openjpeg \
    openjpeg-dev \
    pcre-dev \
    php5 \
    php5-dev \
    php5-embed \
    podofo \
    podofo-dev \
    popt \
    popt-dev \
    postgresql \
    postgresql-dev \
    python2 \
    python2-dev \
    py2-numpy \
    py-numpy-dev \
    py-setuptools \
    scons \
    sqlite \
    sqlite-dev \
    tiff-tools \
    unixodbc \
    unixodbc-dev \
    uriparser \
    uriparser-dev \
    xz \
    zlib \
    zlib-dev

# gdal expects libboost_thread.so :
(cd /usr/lib && ln -s libboost_thread-mt.so libboost_thread.so)
# php-config not found :
(cd /usr/bin && ln -s php-config5 php-config)
# libjvm.so not found :
# Cf. https://www.musl-libc.org/doc/1.0.0/manual.html
#[ ! -f /etc/ld-musl-x86_64.path ] && { echo "/lib:/usr/local/lib:/usr/lib" > /etc/ld-musl-x86_64.path ; }
#echo "/usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64" >> /etc/ld-musl-x86_64.path
#echo "/usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/server" >> /etc/ld-musl-x86_64.path
#ldconfig /

cd /tmp
NPROC=$(nproc)
# compile OpenBLAS/LAPACK needed for Armadillo :
# See https://github.com/xianyi/OpenBLAS
# Fix :
# init.c:841:48: error: missing binary operator before token "("
# #if !defined(__GLIBC_PREREQ) || !__GLIBC_PREREQ(2, 3)
#                                                ^
#init.c:843:21: error: missing binary operator before token "("
#
wget --no-verbose http://github.com/xianyi/OpenBLAS/archive/v0.2.20.tar.gz
tar xzf v0.2.20.tar.gz
rm -f v0.2.20.tar.gz
{ \
    cd OpenBLAS-0.2.20 ; \
    sed -i -e '841s/^\(#if !defined(__GLIBC_PREREQ)\) || \(!__GLIBC_PREREQ(2, 3)\)/\1\ncommon->num_procs = nums ;\n#elif \2/' driver/others/init.c ; \
    make -j$NPROC && \
    make PREFIX=/usr install ; \
    cd .. ; \
    rm -fr OpenBLAS-0.2.20 ; \
}
# compile HDF4
# See https://portal.hdfgroup.org/display/support/HDF+4.2.14
# Fix : force disabling xdr
# Fix : use TI-RPC as in cygwin
wget --no-verbose https://support.hdfgroup.org/ftp/HDF/releases/HDF4.2.14/src/hdf-4.2.14.tar.gz
tar xzf hdf-4.2.14.tar.gz
rm -f hdf-4.2.14.tar.gz
{ \
    cd hdf-4.2.14 ; \
    sed -i -e "23641s/\(\*-pc-cygwin\*)\)/x86_64-unknown-linux-gnu\|\1/" configure ; \
    sed -i -e '23679s/^/BUILD_XDR="no"/' configure ; \
    ./configure \
        --prefix=/usr \
        --disable-fortran \
        --disable-netcdf \
        --enable-shared \
        --disable-hdf4-xdr && \
    make -j$NPROC && \
    make install ; \
    cd .. ; \
    rm -fr hdf-4.2.14 ; \
}
# compile HDF5 (needed for armadillo)
# See https://www.hdfgroup.org/downloads/hdf5/
wget --no-verbose https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-1.8.21/src/hdf5-1.8.21.tar.gz
tar xzf hdf5-1.8.21.tar.gz
rm -f hdf5-1.8.21.tar.gz
{ \
    cd hdf5-1.8.21 ; \
    ./configure \
        --prefix=/usr && \
    make -j$NPROC && \
    make install ; \
    cd .. ; \
    rm -fr hdf5-1.8.21 ; \
}
# compile Armadillo :
# See http://arma.sourceforge.net/download.html
wget --no-verbose http://sourceforge.net/projects/arma/files/armadillo-9.100.5.tar.xz
tar xJf armadillo-9.100.5.tar.xz
rm -f armadillo-9.100.5.tar.xz
{ \
    cd armadillo-9.100.5 ; \
    cmake . -DCMAKE_INSTALL_PREFIX:PATH=/usr && \
    make -j$NPROC && \
    make install ; \
    cd .. ; \
    rm -fr armadillo-9.100.5 ; \
}
# compile CFITSIO :
# See https://heasarc.gsfc.nasa.gov/fitsio/
wget --no-verbose http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3450.tar.gz
tar xzf cfitsio3450.tar.gz
rm -f cfitsio3450.tar.gz
{ \
    cd cfitsio ; \
    ./configure \
        --prefix=/usr && \
    make -j$NPROC && \
    make shared && \
    make install ; \
    cd .. ; \
    rm -fr cfitsio ; \
}
# compile Libdap :
# See https://www.opendap.org/software/libdap/3.18.1
# Fix : use TI-RPC for XDR
wget --no-verbose https://www.opendap.org/pub/source/libdap-3.18.1.tar.gz
tar xzf libdap-3.18.1.tar.gz
rm -f libdap-3.18.1.tar.gz
{ \
    cd libdap-3.18.1 ; \
    sed -i -e "17592s/\(rpcsvc\)/\1 tirpc/" configure ; \
    CPPFLAGS=-I/usr/include/tirpc ./configure \
        --prefix=/usr && \
    make -j$NPROC && \
    make install ; \
    cd .. ; \
    rm -fr libdap-3.18.1 ; \
}
# compile libEPSILON :
# See https://sourceforge.net/projects/epsilon-project/
wget --no-verbose https://sourceforge.net/projects/epsilon-project/files/epsilon/0.9.2/epsilon-0.9.2.tar.gz
tar xzf epsilon-0.9.2.tar.gz
rm -f epsilon-0.9.2.tar.gz
{ \
    cd epsilon-0.9.2 ; \
    ./configure \
        --prefix=/usr && \
    make -j$NPROC && \
    make install ; \
    cd .. ; \
    rm -fr epsilon-0.9.2 ; \
}
# compile FreeXL :
# See https://www.gaia-gis.it/fossil/freexl/index
wget --no-verbose http://www.gaia-gis.it/gaia-sins/freexl-1.0.5.tar.gz
tar xzf freexl-1.0.5.tar.gz
rm -f freexl-1.0.5.tar.gz
{ \
    cd freexl-1.0.5 ; \
    ./configure \
        --prefix=/usr && \
    make -j$NPROC && \
    make install ; \
    cd .. ; \
    rm -fr freexl-1.0.5 ; \
}
# compile KML
# See https://github.com/libkml/libkml/blob/master/INSTALL
wget --no-verbose https://github.com/libkml/libkml/archive/1.3.0.tar.gz
tar xzf 1.3.0.tar.gz
rm -f 1.3.0.tar.gz
{ \
    cd libkml-1.3.0 ; \
    mkdir build ; \
    cd build ; \
    cmake -DCMAKE_INSTALL_PREFIX=/usr \
        ../ && \
    make -j$NPROC && \
    make install ; \
    cd ../.. ; \
    rm -fr libkml-1.3.0 ; \
}
# compile LZMA
# See https://tukaani.org/xz/
wget --no-verbose https://tukaani.org/xz/xz-5.2.4.tar.gz
tar xzf xz-5.2.4.tar.gz
rm -f xz-5.2.4.tar.gz
{ \
    cd xz-5.2.4 ; \
    ./configure \
        --prefix=/usr && \
    make -j$NPROC && \
    make install ; \
    rm -fr /usr/share/doc/xz/
    cd .. ; \
    rm -fr xz-5.2.4 ; \
}
# compile NetCDF
# See https://www.unidata.ucar.edu/software/netcdf/docs/getting_and_building_netcdf.html
wget --no-verbose https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-4.6.1.tar.gz
tar xzf netcdf-4.6.1.tar.gz
rm -f netcdf-4.6.1.tar.gz
{ \
    cd netcdf-4.6.1 ; \
    ./configure \
        --prefix=/usr \
        --enable-hdf4 \
        --disable-dap-remote-tests \
        --disable-testsets \
        --disable-examples && \
    make -j$NPROC && \
    make install ; \
    cd .. ; \
    rm -fr netcdf-4.6.1 ; \
}
# compile GEOS :
# See https://trac.osgeo.org/geos
wget --no-verbose https://github.com/libgeos/geos/archive/3.7.0.tar.gz
tar xzf 3.7.0.tar.gz
rm -f 3.7.0.tar.gz
{ \
    cd geos-3.7.0 ; \
    mkdir build ; \
    cd build ; \
    cmake -DCMAKE_INSTALL_PREFIX=/usr \
        ../ && \
    make -j$NPROC && \
    make install ; \
    cd ../.. ; \
    rm -fr geos-3.7.0 ; \
}
# compile spatialite
# See https://www.gaia-gis.it/fossil/libspatialite/index
# See https://gis.stackexchange.com/questions/48495/how-to-compile-liblwgeom-independently
wget --no-verbose http://www.gaia-gis.it/gaia-sins/libspatialite-4.3.0a.tar.gz
tar xzf libspatialite-4.3.0a.tar.gz
rm -fr libspatialite-4.3.0a.tar.gz
{ \
    cd libspatialite-4.3.0a ; \
    ./configure \
        --prefix=/usr \
        --enable-mathsql \
        --enable-geocallbacks \
        --enable-proj \
        --enable-iconv \
        --enable-freexl \
        --enable-epsg \
        --enable-geos \
        --disable-gcp \
        --enable-geosadvanced \
        --disable-lwgeom \
        --enable-libxml2 \
        --enable-geopackage \
        --enable-gcov \
        --disable-examples && \
    make -j$NPROC && \
    make install ; \
    cd .. ; \
    rm -fr libspatialite-4.3.0a ; \
}
# compile xerces-c
# See https://xerces.apache.org/xerces-c/index.html
wget --no-verbose http://mirrors.standaloneinstaller.com/apache/xerces/c/3/sources/xerces-c-3.2.2.tar.gz
tar xzf xerces-c-3.2.2.tar.gz
rm -f xerces-c-3.2.2.tar.gz
{ \
    cd xerces-c-3.2.2 ; \
    ./configure \
        --prefix=/usr \
        --enable-netaccessor-curl && \
    make -j$NPROC && \
    make install ; \
    cd .. ; \
    rm -fr xerces-c-3.2.2 ; \
}
# compile glib2 necessary for mdbtools
# See https://developer.gnome.org/glib/2.56/glib-building.html
wget --no-verbose https://download.gnome.org/sources/glib/2.56/glib-2.56.3.tar.xz
tar xJf glib-2.56.3.tar.xz
rm -f glib-2.56.3.tar.xz
{ \
    cd glib-2.56.3 ; \
    ./configure \
        --prefix=/usr \
        --disable-gtk-doc \
        --disable-gtk-doc-html \
        --disable-gtk-doc-pdf \
        --disable-man && \
    make -j$NPROC && \
    make install ; \
    cd .. ; \
    rm -fr glib-2.56.3 ; \
}
# compile mdbtools
# See https://github.com/brianb/mdbtools
# removal of java implies removal of MDB
#wget --no-verbose https://github.com/brianb/mdbtools/archive/0.7.1.tar.gz
#tar xzf 0.7.1.tar.gz
#rm -f 0.7.1.tar.gz
#{ \
#    cd mdbtools-0.7.1 ; \
#    autoreconf -i -f && \
#    ./configure \
#        --prefix=/usr \
#        --disable-gtk-doc \
#        --disable-man \
#        --with-unixodbc=/usr && \
#    make -j$NPROC && \
#    make install ; \
#    cd .. ; \
#    rm -fr mdbtools-0.7.1 ; \
#}
# compile mongodb driver (legacy)
# See http://mongocxx.org/legacy-v1/installation/
# Fix : /usr/include/sys/poll.h:1:2: error: #warning redirecting incorrect #include <sys/poll.h> to <poll.h> [-Werror=cpp]
# use --disable-warnings-as-errors
wget --no-verbose https://github.com/mongodb/mongo-cxx-driver/archive/legacy-1.1.3.tar.gz
tar xzf legacy-1.1.3.tar.gz
rm -f legacy-1.1.3.tar.gz
{ \
    cd mongo-cxx-driver-legacy-1.1.3 ; \
    scons \
        --prefix=/usr \
        --disable-warnings-as-errors \
        --sharedclient \
        --ssl \
        -j $NPROC \
        install ; \
    cd .. ; \
    rm -fr mongo-cxx-driver-legacy-1.1.3 ; \
}
# compile gpsbabel
# See https://www.gpsbabel.org/
# configure: error: Qt5.2 or higher is required, but was not found
# => withdrawn (needs qt5-qtbase-dev)
#wget --no-verbose https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_1_5_4.tar.gz
#tar xzf gpsbabel_1_5_4.tar.gz
#rm -f gpsbabel_1_5_4.tar.gz
#{ \
#    cd gpsbabel-gpsbabel_1_5_4 ; \
#    ./configure \
#        --prefix=/usr \
#        --with-zlib=system && \
#    make -j$NPROC && \
#    make install ; \
#    cd .. ; \
#    rm -fr gpsbabel-gpsbabel_1_5_4 ; \
#}

# compile GDAL :
wget --no-verbose "$GDAL_DOWNLOAD_URL"
wget --no-verbose "$GDAL_DOWNLOAD_URL.md5"
md5sum --strict -c gdal-$GDAL_VERSION.tar.gz.md5
tar xzf gdal-$GDAL_VERSION.tar.gz
rm -f gdal-$GDAL_VERSION.tar.gz*
# compiling php :
#gdal_wrap.cpp: In function 'void* SWIG_ZTS_ConvertResourcePtr(zval*, swig_type_info*, int)':
#gdal_wrap.cpp:935:41: error: invalid conversion from ‘const char*’ to ‘char*’ [-fpermissive]
#...
#add -fpermissive and -Wdeprecated-declarations to swig/php/GNUmakefile
# removal of java support:
#        --with-java=/usr/lib/jvm/java-1.8-openjdk \
{ \
    cd gdal-$GDAL_VERSION ; \
    touch config.rpath ; \
    ./configure \
        --prefix=/usr \
        --with-libz=/usr \
        --with-liblzma=yes \
        --with-pg=/usr/bin/pg_config \
        --with-cfitsio=/usr \
        --with-pcraster=internal \
        --with-png=internal \
        --with-libtiff=internal \
        --with-geotiff=internal \
        --with-jpeg=/usr \
        --without-jpeg12 \
        --with-gif=internal \
        --with-hdf4=/usr \
        --with-netcdf=/usr \
        --with-openjpeg \
        --with-mysql=/usr/bin/mysql_config \
        --with-xerces=yes \
        --with-libkml=yes \
        --with-odbc=/usr \
        --with-curl=/usr/bin \
        --with-xml2=/usr/bin \
        --with-mongocxx=/usr \
        --with-spatialite=yes \
        --with-sqlite3=yes \
        --with-pcre \
        --with-epsilon=yes \
        --with-webp=yes \
        --with-geos=yes \
        --with-qhull=internal \
        --with-freexl=yes \
        --with-libjson-c=/usr \
        --with-podofo=yes \
        --with-php \
        --with-python \
        --without-java \
        --without-mdb \
        --with-armadillo=yes && \
        sed -i -e 's/\(CFLAGS=-fpic\)/\1 -fpermissive -Wdeprecated-declarations/' swig/php/GNUmakefile && \
    make -j$NPROC && \
    make install ; \
    cd .. ; \
    rm -fr gdal-$GDAL_VERSION ; \
}

# FIXME: run autotest ...

# clean
# don't auto-remove otherwise all libs are gone (not only headers) :
# removal for java :
#    openjdk8 \
apk del \
    boost-dev \
    curl-dev \
    flex-dev \
    gettext-dev \
    groff \
    jpeg-dev \
    json-c-dev \
    lcms2-dev \
    libffi-dev \
    libjpeg-turbo-dev \
    libtirpc-dev \
    libwebp-dev \
    libxml2-dev \
    mariadb-connector-c-dev \
    mariadb-embedded-dev \
    openjpeg-dev \
    pcre-dev \
    php5-dev \
    podofo-dev \
    popt-dev \
    postgresql-dev \
    python2-dev \
    py-numpy-dev \
    py-setuptools \
    scons \
    sqlite-dev \
    unixodbc-dev \
    uriparser-dev \
    xz \
    zlib-dev

01-uninstall.sh y

exit 0

