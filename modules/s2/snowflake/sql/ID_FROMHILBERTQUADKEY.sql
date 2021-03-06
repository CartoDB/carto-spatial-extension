----------------------------
-- Copyright (C) 2021 CARTO
----------------------------

CREATE OR REPLACE FUNCTION @@SF_PREFIX@@s2._ID_FROMHILBERTQUADKEY
(quadkey STRING)
RETURNS STRING
LANGUAGE JAVASCRIPT
AS $$
    @@SF_LIBRARY_CONTENT@@
    
    if (!QUADKEY) {
        throw new Error('NULL argument passed to UDF');
    }

    return s2Lib.keyToId(QUADKEY);
$$;

CREATE OR REPLACE SECURE FUNCTION @@SF_PREFIX@@s2.ID_FROMHILBERTQUADKEY
(quadkey STRING)
RETURNS BIGINT
AS $$
    CAST(@@SF_PREFIX@@s2._ID_FROMHILBERTQUADKEY(QUADKEY) AS BIGINT)
$$;