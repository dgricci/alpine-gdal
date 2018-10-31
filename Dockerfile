# Dockerfile for GDAL - Geospatial Data Abstraction Library 
FROM dgricci/alpine-proj:5.2.0
MAINTAINER Didier Richard <didier.richard@ign.fr>
LABEL       version="1.0.0" \
            gdal="v2.3.2" \
            os="Alpine Linux 3.8" \
            description="GDAL library and softwares"

ARG GDAL_VERSION
ENV GDAL_VERSION ${GDAL_VERSION:-2.3.2}
ARG GDAL_DOWNLOAD_URL
ENV GDAL_DOWNLOAD_URL ${GDAL_DOWNLOAD_URL:-http://download.osgeo.org/gdal/$GDAL_VERSION/gdal-$GDAL_VERSION.tar.gz}
ARG GDAL_AUTOTEST_DOWNLOAD_URL
ENV GDAL_AUTOTEST_DOWNLOAD_URL ${GDAL_AUTOTEST_DOWNLOAD_URL:-http://download.osgeo.org/gdal/$GDAL_VERSION/gdalautotest-$GDAL_VERSION.tar.gz}

COPY build.sh /tmp/build.sh

RUN /tmp/build.sh && rm -f /tmp/build.sh

# Externally accessible data is by default put in /geodata
# use -v at run time !
WORKDIR /geodata

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats

