----------------------------
-- Copyright (C) 2021 CARTO
----------------------------

CREATE OR REPLACE FUNCTION @@SF_PREFIX@@transformations._LINE_INTERPOLATE_POINT
(geojson STRING, distance DOUBLE, units STRING)
RETURNS STRING
LANGUAGE JAVASCRIPT
AS $$
    @@SF_LIBRARY_CONTENT@@

    if (!GEOJSON || DISTANCE == null || !UNITS) {
        return null;
    }
    const options = {};
    options.units = UNITS;
    const along = transformationsLib.along(JSON.parse(GEOJSON), DISTANCE, options);
    return JSON.stringify(along.geometry);
$$;

CREATE OR REPLACE SECURE FUNCTION @@SF_PREFIX@@transformations.ST_LINE_INTERPOLATE_POINT
(geog GEOGRAPHY, distance DOUBLE)
RETURNS GEOGRAPHY
AS $$
    TO_GEOGRAPHY(@@SF_PREFIX@@transformations._LINE_INTERPOLATE_POINT(CAST(ST_ASGEOJSON(GEOG) AS STRING), DISTANCE, 'kilometers'))
$$;

CREATE OR REPLACE SECURE FUNCTION @@SF_PREFIX@@transformations.ST_LINE_INTERPOLATE_POINT
(geog GEOGRAPHY, distance DOUBLE, units STRING)
RETURNS GEOGRAPHY
AS $$
    TO_GEOGRAPHY(@@SF_PREFIX@@transformations._LINE_INTERPOLATE_POINT(CAST(ST_ASGEOJSON(GEOG) AS STRING), DISTANCE, UNITS))
$$;