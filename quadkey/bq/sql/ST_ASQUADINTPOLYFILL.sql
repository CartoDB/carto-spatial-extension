-----------------------------------------------------------------------
--
-- Copyright (C) 2021 CARTO
--
-----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION `@@BQ_PROJECTID@@.@@BQ_DATASET_QUADKEY@@.POLYFILL_FROMGEOJSON`
    (geojson STRING, level NUMERIC)
    RETURNS ARRAY<INT64>
    DETERMINISTIC
    LANGUAGE js
    OPTIONS (library=["@@QUADKEY_BQ_LIBRARY@@"])
AS """
    let pol = JSON.parse(geojson);
    let quadints = geojsonToQuadints(pol, {min_zoom: level,max_zoom: level});
    return quadints.map(String);
""";

CREATE OR REPLACE FUNCTION `@@BQ_PROJECTID@@.@@BQ_DATASET_QUADKEY@@.ST_ASQUADINTPOLYFILL`
    (geo GEOGRAPHY, resolution NUMERIC)
AS (
    `@@BQ_PROJECTID@@`.@@BQ_DATASET_QUADKEY@@.POLYFILL_FROMGEOJSON(ST_ASGEOJSON(geo),resolution)
);