----------------------------
-- Copyright (C) 2021 CARTO
----------------------------

CREATE OR REPLACE FUNCTION `@@BQ_PREFIX@@h3.KRING`
(index STRING, distance INT64)
RETURNS ARRAY<STRING>
DETERMINISTIC
LANGUAGE js
OPTIONS (library=["@@BQ_LIBRARY_BUCKET@@"])
AS """
    if (!index || distance == null || distance < 0) {
        return null;
    }
    if (!h3Lib.h3IsValid(index)) {
        return null;
    }
    return h3Lib.kRing(index, parseInt(distance));
""";