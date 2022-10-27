
Purpose
=======

Josm currently lacks an easy way to import features from an Standard WFS based
service. So importing/updating for example buildings which are available in 
a lot of regions in the world is basically impossible on a large scale.

For Northrhine-Westfalia there was a solution with the "importer2" plugin 
and a C# based companion tool which downloads WMS image tiles, converts them
back to vectors with the help of OpenVision and then passes it to josm.
This solution seems to be basically unmaintained and does not work very well.

So the idea is to use a different plugin which is capable of importing vectors by
point and click and simply rewrite the server component.

The plugin which works is *plbuildings* used for Building Import in Poland.
By simply changing the URL one can use it for other regions, as long as the server
returns expected output.


Installation
============

Webserver installation:

	cd /var/www/
	git clone https://github.com/flohoff/plbuildingsnrw/
	cd plbuildingsnrw

Create config containing the database informations:

	cp dot-config.plbuildingsnrw.json .config.plbuildingsnrw.json
	vi .config.plbuildingsnrw.json

Configure apache2:

	ScriptAlias /plbuildingsnrw /var/www/plbuildingsnrw/plbuildingsapi
	<Location /plbuildingsnrw/>
		Options ExecCGI
		SetHandler fcgid-script
	</Location>

Install postgres and create database:

	su - postgres -c "createuser dbuser"
	su - postgres -c "createdb hu_nrw -O dbuser"
	su - postgres -c "psql hu_nrw -c 'create extension postgis'

Then download the Hausumringe NRW Shape:

	https://www.opengeodata.nrw.de/produkte/geobasis/lk/akt/hu_shp/

Unzip it and load it into your new database with *ogr2ogr*

	ogr2ogr -f "PostgreSQL" \
		-nlt MULTIPOLYGON \
		-a_srs "EPSG:5652" \
		-nln "hu_nrw" \
		PG:"dbname=hu_nrw" \
		hu_shp.shp

Now you should be ready and this command should return an *osmxml* file:

	curl "https://localhost/plbuildingsnrw/v1?lat=51.904858&lon=8.3486155&daDta_source=bdot&search_distance=3.0"

