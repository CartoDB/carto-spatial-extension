----------------------------
-- Copyright (C) 2021 CARTO
----------------------------

CREATE OR REPLACE FUNCTION @@SF_PREFIX@@placekey._H3_ASPLACEKEY
(h3Index STRING)
RETURNS STRING
LANGUAGE JAVASCRIPT
AS $$
    @@SF_LIBRARY_CONTENT@@
    
    return lib.h3ToPlacekey(H3INDEX);
$$;

CREATE OR REPLACE SECURE FUNCTION @@SF_PREFIX@@placekey.H3_ASPLACEKEY
(h3Index STRING)
RETURNS STRING
AS $$
    IFF(sfcarto.h3.ISVALID(H3INDEX), -- FIXME
      @@SF_PREFIX@@placekey._H3_ASPLACEKEY(H3INDEX),
      null)
$$;