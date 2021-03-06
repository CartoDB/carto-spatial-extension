----------------------------
-- Copyright (C) 2021 CARTO
----------------------------

CREATE OR REPLACE FUNCTION @@SF_PREFIX@@constructors._MAKEELLIPSE
(geojson STRING, xSemiAxis DOUBLE, ySemiAxis DOUBLE, angle DOUBLE, units STRING, steps DOUBLE)
RETURNS STRING
LANGUAGE JAVASCRIPT
AS $$
    @@SF_LIBRARY_CONTENT@@

    if (!GEOJSON || XSEMIAXIS == null || YSEMIAXIS == null || ANGLE == null || !UNITS || STEPS == null) {
        return null;
    }
    const options = {};
    options.angle = Number(ANGLE);
    options.units = UNITS;
    options.steps = Number(STEPS);
    const ellipse = constructorsLib.ellipse(JSON.parse(GEOJSON), Number(XSEMIAXIS), Number(YSEMIAXIS), options);
    return JSON.stringify(ellipse.geometry);
$$;

CREATE OR REPLACE SECURE FUNCTION @@SF_PREFIX@@constructors.ST_MAKEELLIPSE
(geog GEOGRAPHY, xSemiAxis DOUBLE, ySemiAxis DOUBLE)
RETURNS GEOGRAPHY
AS $$
    TO_GEOGRAPHY(@@SF_PREFIX@@constructors._MAKEELLIPSE(CAST(ST_ASGEOJSON(GEOG) AS STRING), XSEMIAXIS, YSEMIAXIS, 0, 'kilometers', 64))
$$;

CREATE OR REPLACE SECURE FUNCTION @@SF_PREFIX@@constructors.ST_MAKEELLIPSE
(geog GEOGRAPHY, xSemiAxis DOUBLE, ySemiAxis DOUBLE, angle DOUBLE)
RETURNS GEOGRAPHY
AS $$
    TO_GEOGRAPHY(@@SF_PREFIX@@constructors._MAKEELLIPSE(CAST(ST_ASGEOJSON(GEOG) AS STRING), XSEMIAXIS, YSEMIAXIS, ANGLE, 'kilometers', 64))
$$;

CREATE OR REPLACE SECURE FUNCTION @@SF_PREFIX@@constructors.ST_MAKEELLIPSE
(geog GEOGRAPHY, xSemiAxis DOUBLE, ySemiAxis DOUBLE, angle DOUBLE, units STRING)
RETURNS GEOGRAPHY
AS $$
    TO_GEOGRAPHY(@@SF_PREFIX@@constructors._MAKEELLIPSE(CAST(ST_ASGEOJSON(GEOG) AS STRING), XSEMIAXIS, YSEMIAXIS, ANGLE, UNITS, 64))
$$;

CREATE OR REPLACE SECURE FUNCTION @@SF_PREFIX@@constructors.ST_MAKEELLIPSE
(geog GEOGRAPHY, xSemiAxis DOUBLE, ySemiAxis DOUBLE, angle DOUBLE, units STRING, steps INT)
RETURNS GEOGRAPHY
AS $$
    TO_GEOGRAPHY(@@SF_PREFIX@@constructors._MAKEELLIPSE(CAST(ST_ASGEOJSON(GEOG) AS STRING), XSEMIAXIS, YSEMIAXIS, ANGLE, UNITS, CAST(STEPS AS DOUBLE)))
$$;