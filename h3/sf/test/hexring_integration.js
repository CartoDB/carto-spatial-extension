const assert = require('assert').strict;
const snowflake = require('snowflake-sdk');

const SF_DATABASEID = process.env.SF_DATABASEID;
const SF_SCHEMA_H3 = process.env.SF_SCHEMA_H3;

function execAsync(connection, sqlText) {
    return new Promise((resolve, reject) => {
        connection.execute({
            sqlText: sqlText,
            complete: (err, stmt, rows) => {
                if (err) {
                    return reject(err);
                } 
                return resolve([stmt, rows]);
            }
        });
    });
}

describe('HEXRING integration tests', () => {
    let connection;
    before(async () => {
        if (!SF_DATABASEID) {
            throw "Missing SF_DATABASEID env variable";
        }
        if (!SF_SCHEMA_H3) {
            throw "Missing SF_SCHEMA_H3 env variable";
        }
        connection = snowflake.createConnection( {
            account: process.env.SNOWSQL_ACCOUNT,
            username: process.env.SNOWSQL_USER,
            password: process.env.SNOWSQL_PWD
            }
        );
        connection.connect( 
            function(err, conn) {
                if (err) {
                    console.error('Unable to connect: ' + err.message);
                } 
                else 
                {
                    // Optional: store the connection ID.
                    connection_ID = conn.getId();
                }
            }
        );
    });

    it ('Works as expected with invalid data', async () => {
        const query = `
WITH ids AS
(
    -- Invalid parameters
    SELECT 1 AS id, NULL as hid, 1 as distance UNION ALL
    SELECT 2 AS id, '0xff283473fffffff' as hid, 1 as distance UNION ALL
    SELECT 3 as id, '0x8928308280fffff' as hid, -1 as distance UNION ALL

    -- Distance 0
    SELECT 4 as id, '0x8928308280fffff' as hid, 0 as distance
)
SELECT
    id,
    ${SF_DATABASEID}.${SF_SCHEMA_H3}.HEXRING(hid, distance) as parent
FROM ids
ORDER BY id ASC
`;

        let rows;
        await assert.doesNotReject(async () => {
            [statement, rows] = await execAsync(connection, query);
        });
        assert.equal(rows.length, 4);
        assert.deepEqual(rows[0].PARENT, []);
        assert.deepEqual(rows[1].PARENT, []);
        assert.deepEqual(rows[2].PARENT, []);
        assert.deepEqual(rows[3].PARENT, ['0x8928308280fffff']);
    });

    it ('List the ring correctly', async () => {
        const query = `
WITH ids AS
(
    SELECT '0x8928308280fffff' as hid
)
SELECT
    ${SF_DATABASEID}.${SF_SCHEMA_H3}.HEXRING(hid, 1) as d1,
    ${SF_DATABASEID}.${SF_SCHEMA_H3}.HEXRING(hid, 2) as d2
FROM ids
`;

        let rows;
        await assert.doesNotReject(async () => {
            [statement, rows] = await execAsync(connection, query);
        });
        assert.equal(rows.length, 1);
        /* Data comes from h3core.spec.js */
        assert.deepEqual(rows[0].D1.sort(),
            [   '0x8928308280bffff',
                '0x89283082807ffff',
                '0x89283082877ffff',
                '0x89283082803ffff',
                '0x89283082873ffff',
                '0x8928308283bffff'
            ].sort());
        assert.deepEqual(rows[0].D2.sort(),
            [   '0x89283082813ffff',
                '0x89283082817ffff',
                '0x8928308281bffff',
                '0x89283082863ffff',
                '0x89283082823ffff',
                '0x8928308287bffff',
                '0x89283082833ffff',
                '0x8928308282bffff',
                '0x89283082857ffff',
                '0x892830828abffff',
                '0x89283082847ffff',
                '0x89283082867ffff'
            ].sort());
    });

    it ('Zero distance returns self', async () => {
        const query = `
WITH ids AS
(
    SELECT '0x87283080dffffff' as hid
)
SELECT
    ${SF_DATABASEID}.${SF_SCHEMA_H3}.HEXRING(hid, 0) AS self_children
FROM ids
`;

        let rows;
        await assert.doesNotReject(async () => {
            [statement, rows] = await execAsync(connection, query);
        });
        assert.equal(rows.length, 1);
        assert.deepEqual(rows[0].SELF_CHILDREN, [ '0x87283080dffffff' ]);
    });
}); /* HEXRING integration tests */
