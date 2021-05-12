----------------------------
-- Copyright (C) 2021 CARTO
----------------------------

CREATE OR REPLACE FUNCTION `@@BQ_PREFIX@@transformations.__GREATCIRCLE`
(geojsonStart STRING, geojsonEnd STRING, npoints INT64)
RETURNS STRING
DETERMINISTIC
LANGUAGE js
OPTIONS (library=["@@BQ_LIBRARY_BUCKET@@"])
AS """
    if (!geojsonStart || !geojsonEnd) {
        return null;
    }
    let options = {};
    if(npoints != null)
    {
        options.npoints = Number(npoints);
    }
    let greatCircle = lib.greatCircle(JSON.parse(geojsonStart), JSON.parse(geojsonEnd), options);
    return JSON.stringify(greatCircle.geometry);
""";

CREATE OR REPLACE FUNCTION `@@BQ_PREFIX@@transformations.ST_GREATCIRCLE`
(startPoint GEOGRAPHY, endPoint GEOGRAPHY, npoints INT64)
AS (
    ST_GEOGFROMGEOJSON(`@@BQ_PREFIX@@transformations.__GREATCIRCLE`(ST_ASGEOJSON(startPoint), ST_ASGEOJSON(endPoint), npoints))
);