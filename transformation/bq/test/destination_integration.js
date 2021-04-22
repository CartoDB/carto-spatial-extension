const assert = require('assert').strict;
const {BigQuery} = require('@google-cloud/bigquery');

const BQ_PROJECTID = process.env.BQ_PROJECTID;
const BQ_DATASET_TRANSFORMATION = process.env.BQ_DATASET_TRANSFORMATION;

describe('ST_DESTINATION integration tests', () => {
    const queryOptions = { 'timeoutMs' : 30000 };
    let client;
    before(async () => {
        if (!BQ_PROJECTID) {
            throw "Missing BQ_PROJECTID env variable";
        }
        if (!BQ_DATASET_TRANSFORMATION) {
            throw "Missing BQ_DATASET_TRANSFORMATION env variable";
        }
        client = new BigQuery({projectId: `${BQ_PROJECTID}`});
    });

    it ('ST_DESTINATION should return NULL if any NULL mandatory argument', async () => {
        let feature = {
            "type": "Point",
            "coordinates": [-100, 50]  
        };
        featureJSON = JSON.stringify(feature);
    
        const query = `SELECT \`${BQ_PROJECTID}\`.\`${BQ_DATASET_TRANSFORMATION}\`.ST_DESTINATION(NULL, 10, 45, "miles") as destination1,
        \`${BQ_PROJECTID}\`.\`${BQ_DATASET_TRANSFORMATION}\`.ST_DESTINATION(ST_GEOGPOINT(-3.70325,40.4167), NULL, 45, "miles") as destination2,
        \`${BQ_PROJECTID}\`.\`${BQ_DATASET_TRANSFORMATION}\`.ST_DESTINATION(ST_GEOGPOINT(-3.70325,40.4167), 10, NULL, "miles") as destination3`;
        
        let rows;
        await assert.doesNotReject( async () => {
            [rows] = await client.query(query, queryOptions);
        });
        assert.equal(rows.length, 1);
        assert.equal(rows[0].destination1, null);
        assert.equal(rows[0].destination2, null);
        assert.equal(rows[0].destination3, null);
    });
}); /* ST_DESTINATION integration tests */