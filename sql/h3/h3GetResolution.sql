CREATE OR REPLACE FUNCTION jslibs.h3.h3GetResolution(h3Index STRING)
 RETURNS NUMERIC
 DETERMINISTIC
 LANGUAGE js AS
"""
return h3.h3GetResolution(h3Index);
"""
OPTIONS (
  library=["gs://bigquery-jslibs/h3-js.umd.js"]
);