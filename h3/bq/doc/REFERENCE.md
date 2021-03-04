## Reference

### H3

[H3](https://eng.uber.com/h3/) is Uber’s Hexagonal Hierarchical Spatial Index. Full documentation of the project can be found at [h3geo](https://h3geo.org/docs).

#### h3.ST_ASH3

{{% bannerNote type="code" %}}
h3.ST_ASH3(geog, resolution) -> INT64
{{%/ bannerNote %}}

* `geog`: `GEOGRAPHY` A **POINT** geography.
* `resolution`: `INT64` A number between 0 and 15 with the [H3 resolution](https://h3geo.org/docs/core-library/restable).

Returns an H3 cell index where the point is placed in the required `resolution` as an `INT64` number. It will return `NULL` on error (invalid geography type or resolution out of bounds).

{{% bannerNote type="note" title="tip"%}}
If you want the HEX representation of the cell, you can call [H3_ASHEX](#h3.H3_ASHEX) with the output integer.
{{%/ bannerNote %}}

{{% bannerNote type="note" title="tip"%}}
If you want the cells covered by a POLYGON see [ST_ASH3_POLYFILL](#h3.ST_ASH3_POLYFILL).
{{%/ bannerNote %}}

#### h3.LONGLAT_ASH3

{{% bannerNote type="code" %}}
h3.LONGLAT_ASH3(longitude, latitude, resolution) -> INT64
{{%/ bannerNote %}}

* `latitude`: `FLOAT64` The point latitude in **degrees**.
* `longitude`: `FLOAT64` The point latitude in **degrees**.
* `resolution`: `INT64` A number between 0 and 15 with the [H3 resolution](https://h3geo.org/docs/core-library/restable).

Returns an H3 cell index where the point is placed in the required `resolution` as an `INT64` number. It will return `NULL` on error (resolution out of bounds).

#### h3.H3_ASHEX

{{% bannerNote type="code" %}}
h3.H3_ASHEX(index) -> STRING
{{%/ bannerNote %}}

* `index`: `INT64` The H3 cell index.

Returns a `STRING` representing the H3 index as a hexadecimal number (8 characters). It doesn't do any extra validation checks.

#### h3.H3_FROMHEX

{{% bannerNote type="code" %}}
h3.H3_FROMHEX(index) -> STRING
{{%/ bannerNote %}}

* `index`: `INT64` The H3 cell index.

Generates the `INT64` representation of a H3 index from the `STRING` (generated by [H3_ASHEX](#h3.H3_ASHEX)) . It doesn't do any extra validation checks.


#### h3.ST_ASH3_POLYFILL

{{% bannerNote type="code" %}}
h3.ST_ASH3_POLYFILL(geography, resolution) -> ARRAY<INT64>
{{%/ bannerNote %}}

* `geography`: `GEOGRAPHY` A **POLYGON** or **MULTIPOLYGON** representing the area to cover.
* `longitude`: `FLOAT64` The point latitude in **degrees**.
* `resolution`: `INT64` A number between 0 and 15 with the [H3 resolution](https://h3geo.org/docs/core-library/restable).

Returns all hexagons **with centers** contained in a given polygon. It will return `NULL` on error (invalid geography type or resolution out of bounds).

#### h3.ST_H3_BOUNDARY

{{% bannerNote type="code" %}}
h3.ST_H3_BOUNDARY(index) -> GEOGRAPHY
{{%/ bannerNote %}}

* `index`: `INT64` The H3 cell index.

Returns a `GEOGRAPHY` representing the H3 cell. It will return `NULL` on error (invalid input).

#### h3.H3_ISVALID

{{% bannerNote type="code" %}}
h3.H3_ISVALID(index) -> BOOLEAN
{{%/ bannerNote %}}

* `index`: `INT64` The H3 cell index.

#### h3.H3_COMPACT

{{% bannerNote type="code" %}}
h3.H3_COMPACT(indexArray) -> ARRAY<INT64>
{{%/ bannerNote %}}

* `indexArray`: `ARRAY<INT64>` An array of H3 cell indices.

Compact a set of hexagons of the same resolution into a set of hexagons across multiple levels that represents the same area.

#### h3.H3_UNCOMPACT

{{% bannerNote type="code" %}}
h3.H3_UNCOMPACT(indexArray, resolution)) -> ARRAY<INT64>
{{%/ bannerNote %}}

* `indexArray`: `ARRAY<INT64>` An array of H3 cell indices.
* `resolution`: `INT64` A number between 0 and 15 with the [H3 resolution](https://h3geo.org/docs/core-library/restable).

Uncompact a compacted set of hexagons to hexagons of the same resolution.

#### h3.H3_TOPARENT

{{% bannerNote type="code" %}}
h3.H3_TOPARENT(index, resolution) -> INT64
{{%/ bannerNote %}}

* `index`: `INT64` The H3 cell index.
* `resolution`: `INT64` A number between 0 and 15 with the [H3 resolution](https://h3geo.org/docs/core-library/restable).

Get the parent of the given hexagon at a particular resolution.

#### h3.H3_TOCHILDREN

{{% bannerNote type="code" %}}
h3.H3_TOCHILDREN(index, resolution) -> ARRAY<INT64>
{{%/ bannerNote %}}

* `index`: `INT64` The H3 cell index.
* `resolution`: `INT64` A number between 0 and 15 with the [H3 resolution](https://h3geo.org/docs/core-library/restable).

Get the children/descendents of the given hexagon at a particular resolution.

#### h3.H3_ISPENTAGON

{{% bannerNote type="code" %}}
h3.H3_ISPENTAGON(index) -> BOOLEAN
{{%/ bannerNote %}}

* `index`: `INT64` The H3 cell index.

Whether the given H3 index is a pentagon. Returns false on invalid input.

#### h3.H3_DISTANCE

{{% bannerNote type="code" %}}
h3.H3_DISTANCE(origin, destination) -> INT64
{{%/ bannerNote %}}

* `origin`: `INT64` The origin H3 cell index.
* `destination`: `INT64` The destination H3 cell index.

Get the **grid distance** between two hex indexes. This function may fail to find the distance between two indexes if they are very far apart or on opposite sides of a pentagon.
Returns null on failure or invalid input.

{{% bannerNote type="note" title="tip"%}}
If you want the distance in meters use [ST_DISTANCE](https://cloud.google.com/bigquery/docs/reference/standard-sql/geography_functions#st_distance) between the cells ([ST_H3_BOUNDARY](#h3.h3.ST_H3_BOUNDARY)) or their centroid.
{{%/ bannerNote %}}

#### h3.H3_KRING

{{% bannerNote type="code" %}}
h3.H3_KRING(index, resolution) -> ARRAY<INT64>
{{%/ bannerNote %}}

* `index`: `INT64` The H3 cell index.
* `distance`: `INT64` Distance (in cells) to the source.

Get all hexagons in a k-ring around a given center. The order of the hexagons is undefined. Returns NULL on invalid input.

#### h3.H3_HEXRING

{{% bannerNote type="code" %}}
h3.H3_HEXRING(index, resolution) -> ARRAY<INT64>
{{%/ bannerNote %}}

* `index`: `INT64` The H3 cell index.
* `distance`: `INT64` Distance (in cells) to the source.

Get all hexagons in a **hollow hexagonal ring** centered at origin with sides of a given length. Unlike kRing, this function will return NULL if there is a pentagon anywhere in the ring.

#### h3.VERSION

{{% bannerNote type="code" %}}
h3.VERSION()
{{%/ bannerNote %}}

Returns a `STRING` with the current version of the h3 library.