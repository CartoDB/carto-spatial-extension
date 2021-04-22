-----------------------------------------------------------------------
--
-- Copyright (C) 2021 CARTO
--
-----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION `@@BQ_PROJECTID@@.@@BQ_DATASET_MEASUREMENT@@.__BEARING`
    (geojsonStart STRING, geojsonEnd STRING)
    RETURNS FLOAT64
    DETERMINISTIC
    LANGUAGE js
    OPTIONS (library=["@@MEASUREMENT_BQ_LIBRARY@@"])
AS """
    if (!geojsonStart || !geojsonEnd) {
        return null;
    }
    return turf.bearing(JSON.parse(geojsonStart), JSON.parse(geojsonEnd));
""";

CREATE OR REPLACE FUNCTION `@@BQ_PROJECTID@@.@@BQ_DATASET_MEASUREMENT@@.ST_BEARING`
    (startPoint GEOGRAPHY, endPoint GEOGRAPHY)
AS (
    `@@BQ_PROJECTID@@`.@@BQ_DATASET_MEASUREMENT@@.__BEARING(ST_ASGEOJSON(startPoint), ST_ASGEOJSON(endPoint))
);