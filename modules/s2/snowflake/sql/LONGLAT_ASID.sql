----------------------------
-- Copyright (C) 2021 CARTO
----------------------------

CREATE OR REPLACE FUNCTION @@SF_PREFIX@@s2._LONGLAT_ASID
(longitude DOUBLE, latitude DOUBLE, resolution DOUBLE)
RETURNS STRING
LANGUAGE JAVASCRIPT
AS $$
    @@SF_LIBRARY_CONTENT@@
    
    if (LATITUDE == null || LONGITUDE == null || RESOLUTION == null) {
        throw new Error('NULL argument passed to UDF');
    }
    const key = s2Lib.latLngToKey(Number(LATITUDE), Number(LONGITUDE), Number(RESOLUTION));
    return s2Lib.keyToId(key);
$$;

CREATE OR REPLACE SECURE FUNCTION @@SF_PREFIX@@s2.LONGLAT_ASID
(longitude DOUBLE, latitude DOUBLE, resolution INT)
RETURNS BIGINT
AS $$
    CAST(@@SF_PREFIX@@s2._LONGLAT_ASID(LONGITUDE, LATITUDE, CAST(RESOLUTION AS DOUBLE)) AS BIGINT)
$$;