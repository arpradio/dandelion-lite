import dotenv from 'dotenv';
import path from 'path'

dotenv.config({ path: path.resolve(__dirname, '../.env') });

const statusLog=[];

export const updateStatusLog=async()=>{
    //TODO
}

export const getConfig=async()=>{   
    const config={
        version:'0.0.1',
        port:process.env.PORT
            ?parseInt(String(process.env.PORT), 10)
            :4000,
        cors:['true','TRUE'].includes(process.env.CORS || 'false'),
        timeout:5000,
        ogmios:{
            connection:{
                host: process.env.USE_OGMIOS_HOST||"127.0.0.1",
                port: process.env.USE_OGMIOS_PORT
                    ?parseInt(String(process.env.USE_OGMIOS_PORT), 10)
                    :1337,
            }
        },
    }
    const nodeGroups=(process.env.NODE_GROUPS||'')
        .split(',')
        .map(x=>((x||"").trim()))
        .filter(x=>!!x);
    const extensions=(process.env.NODE_EXTENSIONS||'')
        .split(',')
        .map(x=>((x||"").trim()))
        .filter(x=>!!x);
    const cardanoSqlExtensions=(process.env.CARDANO_SQL_EXTENSIONS||'')
        .split(',')
        .map(x=>((x||"").trim()))
        .filter(x=>!!x);
    return {
        ...config,
        info:{
            manifest:{
                dltTag      :process.env.DLT,
                networkTag  :process.env.NETWORK,
                name        :process.env.NODE_NAME,
                groups      :nodeGroups,
                extensions,
                extension:{
                    'cardano_node':{
                        enabled:extensions.includes('cardano_node'),
                        version:process.env.CARDANO_NODE_VERSION,
                        image:process.env.CARDANO_NODE_IMAGE,
                        status:'ONLINE',
                    },
                    'cardano_db_sync':{
                        enabled:extensions.includes('cardano_db_sync'),
                        version:process.env.CARDANO_DB_SYNC_VERSION,
                        image:process.env.CARDANO_DB_SYNC_IMAGE,
                        status:'ONLINE',
                    },
                    'cf_ledger_sync':{
                        enabled:extensions.includes('cf_ledger_sync'),
                        version:process.env.CF_LEDGER_SYNC_VERSION,
                        image:process.env.CF_LEDGER_SYNC_IMAGE,
                        status:'OFFLINE',
                    },                    
                    'ogmios':{
                        enabled:extensions.includes('ogmios'),
                        port:config.ogmios.connection.port,
                        version:process.env.OGMIOS_VERSION,
                        image:process.env.OGMIOS_IMAGE,
                        status:'ONLINE',
                    },
                    'postgrest':{
                        enabled:extensions.includes('postgrest'),
                        port:process.env.POSTGREST_PORT,
                        status:'ONLINE',
                    },
                    'koios':{
                        enabled:extensions.includes('koios'),
                        port:process.env.POSTGREST_PORT,
                        status:'ONLINE',
                    },
                    'cardano_sql':{
                        enabled:extensions.includes('cardano_sql'),
                        extensions:cardanoSqlExtensions,
                        version:config.version,
                        port:process.env.CARDANO_SQL_COMPANION_PORT,
                        status:'ONLINE',
                    },
                    'unimatrix':{
                        enabled:extensions.includes('unimatrix'),
                        status:'OFFLINE',
                    },
                    'gcfs':{
                        enabled:extensions.includes('gcfs'),
                        status:'OFFLINE',
                    },
                    'pgadmin':{
                        enabled:extensions.includes('pgadmin'),
                        port:process.env.PGADMIN_PORT,
                        status:'ONLINE',
                    },
                    'swagger':{
                        enabled:extensions.includes('swagger'),
                        port:process.env.SWAGGER_PORT,
                        status:'ONLINE',
                    },
                }
            }
        }
    }
}