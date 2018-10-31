% GDAL - Geospatial Data Abstraction Library  
% Didier Richard  
% 2018/09/30

---

revision:
    - 1.0.0 : 2018/09/30 : proj 5.2.0, gdal 2.3.2  

---

# Building #

```bash
$ docker build -t dgricci/alpine-gdal:$(< VERSION) .
$ docker tag dgricci/alpine-gdal:$(< VERSION) dgricci/alpine-gdal:latest
```

## Behind a proxy (e.g. 10.0.4.2:3128) ##

```bash
$ docker build \
    --build-arg http_proxy=http://10.0.4.2:3128/ \
    --build-arg https_proxy=http://10.0.4.2:3128/ \
    -t dgricci/alpine-gdal:$(< VERSION) .
$ docker tag dgricci/alpine-gdal:$(< VERSION) dgricci/alpine-gdal:latest
```

## Build command with arguments default values ##

```bash
$ docker build \
    --build-arg GDAL_VERSION=2.3.2 \
    --build-arg GDAL_DOWNLOAD_URL=http://download.osgeo.org/gdal/2.3.2/gdal-2.3.2.tar.gz \
    -t dgricci/alpine-gdal:$(< VERSION) .
$ docker tag dgricci/alpine-gdal:$(< VERSION) dgricci/alpine-gdal:latest
```

# Use #

See `dgricci/alpine` README for handling permissions with dockers volumes.

```bash
$ docker run --rm dgricci/alpine-gdal:$(< VERSION)
GDAL 2.3.2, released 2018/09/21
Supported Formats:
  VRT -raster- (rw+v): Virtual Raster
  DERIVED -raster- (ro): Derived datasets using VRT pixel functions
  GTiff -raster- (rw+vs): GeoTIFF
  NITF -raster- (rw+vs): National Imagery Transmission Format
  RPFTOC -raster- (rovs): Raster Product Format TOC format
  ECRGTOC -raster- (rovs): ECRG TOC format
  HFA -raster- (rw+v): Erdas Imagine Images (.img)
  SAR_CEOS -raster- (rov): CEOS SAR Image
  CEOS -raster- (rov): CEOS Image
  JAXAPALSAR -raster- (rov): JAXA PALSAR Product Reader (Level 1.1/1.5)
  GFF -raster- (rov): Ground-based SAR Applications Testbed File Format (.gff)
  ELAS -raster- (rw+v): ELAS
  AIG -raster- (rov): Arc/Info Binary Grid
  AAIGrid -raster- (rwv): Arc/Info ASCII Grid
  GRASSASCIIGrid -raster- (rov): GRASS ASCII Grid
  SDTS -raster- (rov): SDTS Raster
  DTED -raster- (rwv): DTED Elevation Raster
  PNG -raster- (rwv): Portable Network Graphics
  JPEG -raster- (rwv): JPEG JFIF
  MEM -raster- (rw+): In Memory Raster
  JDEM -raster- (rov): Japanese DEM (.mem)
  GIF -raster- (rwv): Graphics Interchange Format (.gif)
  BIGGIF -raster- (rov): Graphics Interchange Format (.gif)
  ESAT -raster- (rov): Envisat Image Format
  FITS -raster- (rw+): Flexible Image Transport System
  BSB -raster- (rov): Maptech BSB Nautical Charts
  XPM -raster- (rwv): X11 PixMap Format
  BMP -raster- (rw+v): MS Windows Device Independent Bitmap
  DIMAP -raster- (rov): SPOT DIMAP
  AirSAR -raster- (rov): AirSAR Polarimetric Image
  RS2 -raster- (rovs): RadarSat 2 XML Product
  SAFE -raster- (rov): Sentinel-1 SAR SAFE Product
  PCIDSK -raster,vector- (rw+v): PCIDSK Database File
  PCRaster -raster- (rw+): PCRaster Raster File
  ILWIS -raster- (rw+v): ILWIS Raster Map
  SGI -raster- (rw+v): SGI Image File Format 1.0
  SRTMHGT -raster- (rwv): SRTMHGT File Format
  Leveller -raster- (rw+v): Leveller heightfield
  Terragen -raster- (rw+v): Terragen heightfield
  GMT -raster- (rw): GMT NetCDF Grid Format
  netCDF -raster,vector- (rw+s): Network Common Data Format
  HDF4 -raster- (ros): Hierarchical Data Format Release 4
  HDF4Image -raster- (rw+): HDF4 Dataset
  ISIS3 -raster- (rw+v): USGS Astrogeology ISIS cube (Version 3)
  ISIS2 -raster- (rw+v): USGS Astrogeology ISIS cube (Version 2)
  PDS -raster- (rov): NASA Planetary Data System
  PDS4 -raster- (rw+vs): NASA Planetary Data System 4
  VICAR -raster- (rov): MIPL VICAR file
  TIL -raster- (rov): EarthWatch .TIL
  ERS -raster- (rw+v): ERMapper .ers Labelled
  JP2OpenJPEG -raster,vector- (rwv): JPEG-2000 driver based on OpenJPEG library
  L1B -raster- (rovs): NOAA Polar Orbiter Level 1b Data Set
  FIT -raster- (rwv): FIT Image
  GRIB -raster- (rwv): GRIdded Binary (.grb, .grb2)
  RMF -raster- (rw+v): Raster Matrix Format
  WCS -raster- (rovs): OGC Web Coverage Service
  WMS -raster- (rwvs): OGC Web Map Service
  MSGN -raster- (rov): EUMETSAT Archive native (.nat)
  RST -raster- (rw+v): Idrisi Raster A.1
  INGR -raster- (rw+v): Intergraph Raster
  GSAG -raster- (rwv): Golden Software ASCII Grid (.grd)
  GSBG -raster- (rw+v): Golden Software Binary Grid (.grd)
  GS7BG -raster- (rw+v): Golden Software 7 Binary Grid (.grd)
  COSAR -raster- (rov): COSAR Annotated Binary Matrix (TerraSAR-X)
  TSX -raster- (rov): TerraSAR-X Product
  COASP -raster- (ro): DRDC COASP SAR Processor Raster
  R -raster- (rwv): R Object Data Store
  MAP -raster- (rov): OziExplorer .MAP
  KMLSUPEROVERLAY -raster- (rwv): Kml Super Overlay
  WEBP -raster- (rwv): WEBP
  PDF -raster,vector- (rw+s): Geospatial PDF
  Rasterlite -raster- (rwvs): Rasterlite
  MBTiles -raster,vector- (rw+v): MBTiles
  PLMOSAIC -raster- (ro): Planet Labs Mosaics API
  CALS -raster- (rwv): CALS (Type 1)
  WMTS -raster- (rwv): OGC Web Map Tile Service
  SENTINEL2 -raster- (rovs): Sentinel 2
  MRF -raster- (rw+v): Meta Raster Format
  PNM -raster- (rw+v): Portable Pixmap Format (netpbm)
  DOQ1 -raster- (rov): USGS DOQ (Old Style)
  DOQ2 -raster- (rov): USGS DOQ (New Style)
  PAux -raster- (rw+v): PCI .aux Labelled
  MFF -raster- (rw+v): Vexcel MFF Raster
  MFF2 -raster- (rw+): Vexcel MFF2 (HKV) Raster
  FujiBAS -raster- (rov): Fuji BAS Scanner Image
  GSC -raster- (rov): GSC Geogrid
  FAST -raster- (rov): EOSAT FAST Format
  BT -raster- (rw+v): VTP .bt (Binary Terrain) 1.3 Format
  LAN -raster- (rw+v): Erdas .LAN/.GIS
  CPG -raster- (rov): Convair PolGASP
  IDA -raster- (rw+v): Image Data and Analysis
  NDF -raster- (rov): NLAPS Data Format
  EIR -raster- (rov): Erdas Imagine Raw
  DIPEx -raster- (rov): DIPEx
  LCP -raster- (rwv): FARSITE v.4 Landscape File (.lcp)
  GTX -raster- (rw+v): NOAA Vertical Datum .GTX
  LOSLAS -raster- (rov): NADCON .los/.las Datum Grid Shift
  NTv2 -raster- (rw+vs): NTv2 Datum Grid Shift
  CTable2 -raster- (rw+v): CTable2 Datum Grid Shift
  ACE2 -raster- (rov): ACE2
  SNODAS -raster- (rov): Snow Data Assimilation System
  KRO -raster- (rw+v): KOLOR Raw
  ROI_PAC -raster- (rw+v): ROI_PAC raster
  RRASTER -raster- (rw+v): R Raster
  ARG -raster- (rwv): Azavea Raster Grid format
  RIK -raster- (rov): Swedish Grid RIK (.rik)
  USGSDEM -raster- (rwv): USGS Optional ASCII DEM (and CDED)
  GXF -raster- (rov): GeoSoft Grid Exchange Format
  BAG -raster- (ro): Bathymetry Attributed Grid
  HDF5 -raster- (ros): Hierarchical Data Format Release 5
  HDF5Image -raster- (ro): HDF5 Dataset
  NWT_GRD -raster- (rw+v): Northwood Numeric Grid Format .grd/.tab
  NWT_GRC -raster- (rov): Northwood Classified Grid Format .grc/.tab
  ADRG -raster- (rw+vs): ARC Digitized Raster Graphics
  SRP -raster- (rovs): Standard Raster Product (ASRP/USRP)
  BLX -raster- (rwv): Magellan topo (.blx)
  EPSILON -raster- (rwv): Epsilon wavelets
  PostGISRaster -raster- (rws): PostGIS Raster driver
  SAGA -raster- (rw+v): SAGA GIS Binary Grid (.sdat, .sg-grd-z)
  XYZ -raster- (rwv): ASCII Gridded XYZ
  HF2 -raster- (rwv): HF2/HFZ heightfield raster
  OZI -raster- (rov): OziExplorer Image File
  CTG -raster- (rov): USGS LULC Composite Theme Grid
  E00GRID -raster- (rov): Arc/Info Export E00 GRID
  ZMap -raster- (rwv): ZMap Plus Grid
  NGSGEOID -raster- (rov): NOAA NGS Geoid Height Grids
  IRIS -raster- (rov): IRIS data (.PPI, .CAPPi etc)
  PRF -raster- (rov): Racurs PHOTOMOD PRF
  RDA -raster- (ro): DigitalGlobe Raster Data Access driver
  GPKG -raster,vector- (rw+vs): GeoPackage
  CAD -raster,vector- (rovs): AutoCAD Driver
  PLSCENES -raster,vector- (ro): Planet Labs Scenes API
  GenBin -raster- (rov): Generic Binary (.hdr Labelled)
  ENVI -raster- (rw+v): ENVI .hdr Labelled
  EHdr -raster- (rw+v): ESRI .hdr Labelled
  ISCE -raster- (rw+v): ISCE raster
  HTTP -raster,vector- (ro): HTTP Fetching Wrapper
Supported Formats:
  PCIDSK -raster,vector- (rw+v): PCIDSK Database File
  netCDF -raster,vector- (rw+s): Network Common Data Format
  JP2OpenJPEG -raster,vector- (rwv): JPEG-2000 driver based on OpenJPEG library
  PDF -raster,vector- (rw+s): Geospatial PDF
  MBTiles -raster,vector- (rw+v): MBTiles
  ESRI Shapefile -vector- (rw+v): ESRI Shapefile
  MapInfo File -vector- (rw+v): MapInfo File
  UK .NTF -vector- (rov): UK .NTF
  OGR_SDTS -vector- (rov): SDTS
  S57 -vector- (rw+v): IHO S-57 (ENC)
  DGN -vector- (rw+v): Microstation DGN
  OGR_VRT -vector- (rov): VRT - Virtual Datasource
  REC -vector- (ro): EPIInfo .REC 
  Memory -vector- (rw+): Memory
  BNA -vector- (rw+v): Atlas BNA
  CSV -vector- (rw+v): Comma Separated Value (.csv)
  NAS -vector- (rov): NAS - ALKIS
  GML -vector- (rw+v): Geography Markup Language (GML)
  GPX -vector- (rw+v): GPX
  LIBKML -vector- (rw+v): Keyhole Markup Language (LIBKML)
  KML -vector- (rw+v): Keyhole Markup Language (KML)
  GeoJSON -vector- (rw+v): GeoJSON
  ESRIJSON -vector- (rov): ESRIJSON
  TopoJSON -vector- (rov): TopoJSON
  Interlis 1 -vector- (rw+v): Interlis 1
  Interlis 2 -vector- (rw+v): Interlis 2
  OGR_GMT -vector- (rw+v): GMT ASCII Vectors (.gmt)
  GPKG -raster,vector- (rw+vs): GeoPackage
  SQLite -vector- (rw+v): SQLite / Spatialite
  ODBC -vector- (rw+): ODBC
  WAsP -vector- (rw+v): WAsP .map format
  PGeo -vector- (ro): ESRI Personal GeoDatabase
  MSSQLSpatial -vector- (rw+): Microsoft SQL Server Spatial Database
  PostgreSQL -vector- (rw+): PostgreSQL/PostGIS
  MySQL -vector- (rw+): MySQL
  OpenFileGDB -vector- (rov): ESRI FileGDB
  XPlane -vector- (rov): X-Plane/Flightgear aeronautical data
  DXF -vector- (rw+v): AutoCAD DXF
  CAD -raster,vector- (rovs): AutoCAD Driver
  Geoconcept -vector- (rw+v): Geoconcept
  GeoRSS -vector- (rw+v): GeoRSS
  GPSTrackMaker -vector- (rw+v): GPSTrackMaker
  VFK -vector- (ro): Czech Cadastral Exchange Data Format
  PGDUMP -vector- (w+v): PostgreSQL SQL dump
  OSM -vector- (rov): OpenStreetMap XML and PBF
  GPSBabel -vector- (rw+): GPSBabel
  SUA -vector- (rov): Tim Newport-Peace's Special Use Airspace Format
  OpenAir -vector- (rov): OpenAir
  OGR_PDS -vector- (rov): Planetary Data Systems TABLE
  WFS -vector- (rov): OGC WFS (Web Feature Service)
  WFS3 -vector- (ro): OGC WFS 3 client (Web Feature Service)
  HTF -vector- (rov): Hydrographic Transfer Vector
  AeronavFAA -vector- (rov): Aeronav FAA
  Geomedia -vector- (ro): Geomedia .mdb
  EDIGEO -vector- (rov): French EDIGEO exchange format
  GFT -vector- (rw+): Google Fusion Tables
  SVG -vector- (rov): Scalable Vector Graphics
  CouchDB -vector- (rw+): CouchDB / GeoCouch
  Cloudant -vector- (rw+): Cloudant / CouchDB
  Idrisi -vector- (rov): Idrisi Vector (.vct)
  ARCGEN -vector- (rov): Arc/Info Generate
  SEGUKOOA -vector- (rov): SEG-P1 / UKOOA P1/90
  SEGY -vector- (rov): SEG-Y
  XLS -vector- (ro): MS Excel format
  ODS -vector- (rw+v): Open Document/ LibreOffice / OpenOffice Spreadsheet 
  XLSX -vector- (rw+v): MS Office Open XML spreadsheet
  ElasticSearch -vector- (rw+): Elastic Search
  Walk -vector- (ro): Walk
  Carto -vector- (rw+): Carto
  AmigoCloud -vector- (rw+): AmigoCloud
  SXF -vector- (rov): Storage and eXchange Format
  Selafin -vector- (rw+v): Selafin
  JML -vector- (rw+v): OpenJUMP JML
  PLSCENES -raster,vector- (ro): Planet Labs Scenes API
  CSW -vector- (ro): OGC CSW (Catalog  Service for the Web)
  MongoDB -vector- (ro): MongoDB
  VDV -vector- (rw+v): VDV-451/VDV-452/INTREST Data Format
  GMLAS -vector- (rwv): Geography Markup Language (GML) driven by application schemas
  MVT -vector- (rw+v): Mapbox Vector Tiles
  TIGER -vector- (rw+v): U.S. Census TIGER/Line
  AVCBin -vector- (rov): Arc/Info Binary Coverage
  AVCE00 -vector- (rov): Arc/Info E00 (ASCII) Coverage
  HTTP -raster,vector- (ro): HTTP Fetching Wrapper
```


_fin du document[^pandoc_gen]_

[^pandoc_gen]: document généré via $ `pandoc -V fontsize=10pt -V geometry:"top=2cm, bottom=2cm, left=1cm, right=1cm" -s -N --toc -o alpine-gdal.pdf README.md`{.bash}
