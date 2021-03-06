### ISVALID

{{% bannerNote type="code" %}}
placekey.ISVALID(placekey)
{{%/ bannerNote %}}

**Description**

Returns a boolean value `true` when the given string represents a valid Placekey, `false` otherwise.

* `placekey`: `STRING` Placekey identifier.

**Return type**

`BOOLEAN`

**Examples**

```sql
SELECT sfcarto.placekey.ISVALID('@ff7-swh-m49');
-- true
```

```sql
SELECT sfcarto.placekey.ISVALID('ff7-swh-m49');
-- true
```

```sql
SELECT sfcarto.placekey.ISVALID('x');
-- false
```