----------------------------
-- Copyright (C) 2021 CARTO
----------------------------

CREATE OR REPLACE FUNCTION @@SF_PREFIX@@transformations._CENTERMEDIAN
(geojson STRING)
RETURNS STRING
LANGUAGE JAVASCRIPT
AS $$
    @@SF_LIBRARY_CONTENT@@

    if (!GEOJSON) {
        return null;
    }
    const medianCenter = transformationsLib.centerMedian(transformationsLib.feature(JSON.parse(GEOJSON)));
    return JSON.stringify(medianCenter.geometry);
$$;

CREATE OR REPLACE SECURE FUNCTION @@SF_PREFIX@@transformations.ST_CENTERMEDIAN
(geog GEOGRAPHY)
RETURNS GEOGRAPHY
AS $$
    TO_GEOGRAPHY(@@SF_PREFIX@@transformations._CENTERMEDIAN(CAST(ST_ASGEOJSON(GEOG) AS STRING)))
$$;