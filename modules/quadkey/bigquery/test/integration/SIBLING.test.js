const { runQuery } = require('../../../../../common/bigquery/test-utils');

test('SIBLING should work at any level of zoom', async () => {
    const query = `WITH zoomContext AS (
            WITH zoomValues AS (
                SELECT zoom FROM UNNEST (GENERATE_ARRAY(0,29)) AS zoom
            )
            SELECT *
            FROM
                zoomValues,
                UNNEST(GENERATE_ARRAY(0,CAST(pow(2, zoom) - 1 AS INT64),COALESCE(NULLIF(CAST(pow(2, zoom)*0.02 AS INT64),0),1))) tileX,
                UNNEST(GENERATE_ARRAY(0,CAST(pow(2, zoom) - 1 AS INT64),COALESCE(NULLIF(CAST(pow(2, zoom)*0.02 AS INT64),0),1))) tileY
        ),
        expectedQuadintContext AS (
            SELECT *,
            \`@@BQ_PREFIX@@quadkey.QUADINT_FROMZXY\`(zoom, tileX, tileY) AS expectedQuadint,
            FROM zoomContext
        ),
        rightSiblingContext AS (
            SELECT *,
            \`@@BQ_PREFIX@@quadkey.SIBLING\`(expectedQuadint,'right') AS rightSibling
            FROM expectedQuadintContext 
        ),
        upSiblingContext AS (
            SELECT *,
            \`@@BQ_PREFIX@@quadkey.SIBLING\`(rightSibling,'up') AS upSibling
            FROM rightSiblingContext 
        ),
        leftSiblingContext AS (
            SELECT *,
            \`@@BQ_PREFIX@@quadkey.SIBLING\`(upSibling,'left') AS leftSibling
            FROM upSiblingContext 
        ),
        downSiblingContext AS (
            SELECT *,
            \`@@BQ_PREFIX@@quadkey.SIBLING\`(leftSibling,'down') AS downSibling
            FROM leftSiblingContext 
        )
        SELECT *
        FROM downSiblingContext
        WHERE downSibling != expectedQuadint`;
    const rows = await runQuery(query);
    expect(rows.length).toEqual(0);
});

test('SIBLING should fail if any NULL argument', async () => {
    let query = 'SELECT `@@BQ_PREFIX@@quadkey.SIBLING`(NULL, "up")';
    await expect(runQuery(query)).rejects.toThrow();

    query = 'SELECT `@@BQ_PREFIX@@quadkey.SIBLING`(322, NULL)';
    await expect(runQuery(query)).rejects.toThrow();
});