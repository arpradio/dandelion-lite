// Cardano Ogmios Client Lib for browser and nodejs
// Based on GC Cardano Ogmios Client Lib
// IMPORTANT: Ogmios v6.1.* is not supported anymore by this code.

import {getServerHealth,Connection,arrayBufferToBase64} from './common'

/**
 * Comment out if clashing with native browser API
 */
const WebSocket = require('isomorphic-ws'); //for node and browser

const logger=console;

function wsp(client:WebSocket,methodname:string, args:any) {
    client.send(JSON.stringify({
        type: "jsonwsp/request",
        version: "1.0",
        servicename: "ogmios",
        methodname,
        args
    }));
}

export function OgmiosErrList2Obj(errList:Array<any>):any{
    let resObj={};
    (errList||[]).forEach(entry=>{
        let codes= Object.keys(entry)||[];
        //logger.error({codes,errList});
        
        (codes||[]).forEach(code=>{
            let errObj=entry[code];
            //logger.error({code,errObj});
            if (resObj[code]===undefined)
                resObj[code]=errObj;
            else 
            if (Array.isArray(resObj[code]))
                resObj[code]=[...(resObj[code]||[]),errObj];
            else 
                resObj[code]={...(resObj[code]||{}),...errObj};
            
        });
    });
    return resObj;
}

export function OgmiosErrList2ErrObj(_errList:any):any{
    let allCodes:Array<string>=[];
    let numErrors:number=0;
    if(Array.isArray(_errList))
        [...(_errList||[])].forEach(entry=>{
            let codes= Object.keys(entry)||[]
            allCodes=[...allCodes,...codes]
            numErrors+=codes.length;
        });
    else 
        Object.keys(_errList||{}).forEach(entry=>{
            let codes= Object.keys(_errList[entry])||[]
            allCodes=[...allCodes,`${entry}(${codes.join(', ')})`]
            numErrors+=codes.length;
        }); 
    return{
        //errMessage:`Failed with ${numErrors>1?`${numErrors} errors`:"error"}: ${allCodes.join(", ")}`,
        //errMessage:`${numErrors} error${numErrors>1?"s":""}: ${allCodes.join(", ")}`,
        errMessage:`${allCodes.join(", ")}`,
        message:_errList,//JSON.stringify(_errList,null,2),
        code:allCodes.join(",") //probably should turn into a unique code
    }
}

const WS_ERR_NORMAL_CLOSURE=1000
const wsErrCodes:{[key:string]:string}={
    "1000":"Normal Closure",
    "1001":"Going Away",
    "1002":"Protocol error",
    "1003":"Unsupported Data",
    "1004":"Reserved",
    "1005":"No Status Rcvd",
    "1006":"Abnormal Closure",
    "1007":"Invalid frame payload data",
    "1008":"Policy Violation",
    "1009":"Message Too Big",
    "1010":"Mandatory Ext.",
    "1011":"Internal Server Error",
    "1015":"TLS handshake",
}

export const startCardanoOgmiosClient=(url="wss://d.ogmios-api.testnet.dandelion.link",apiKey?:string,options?:any):Promise<WebSocket>=>{
    const {
        exitOnNotSynced,
        exitOnError,
        onNormalClose,
        onAbnormalClose,
    }=options||{};
    const _128MB = 128 * 1024 * 1024
    let isTls=url.startsWith("wss://"); 
    let protoHostPort=url.split('://')[1]
    let host=protoHostPort.split(':')[0];    
    let port=protoHostPort.split(':')[1]?parseInt(protoHostPort.split(':')[1]):(isTls?443:80);
    const connection:Connection={
        host,
        port,
        tls: isTls,
        maxPayload: _128MB,//134217728,
        address: {
            webSocket:`${isTls?'wss':'ws'}://${host}:${port}`,
            http:`${isTls?'https':'http'}://${host}:${port}`
        }
    }
    logger.log({OGMIOS:connection})

    return new Promise(async (resolve,reject)=>{
        try{
            const health=await getServerHealth({connection});
            const{networkSynchronization}=health;
            if(networkSynchronization<0.99)
                logger.warn(`Warning: node is out of sync (${(networkSynchronization*100).toFixed(1)} %)`)
            //logger.log({health})
        }catch(err){
            reject (Error(`Ogmios error. ${err.message}`));
        }
        let client:WebSocket;
        try{
            client = new WebSocket(url); // format: "ws://localhost:1337"
        }catch(err){
            reject (Error(`Ogmios error. ${err.message}`));
        }
        const errorHandler = ( ev: Event):any =>{
            //logger.log({ev})
            //throw Error(`Ogmios error. ${String(ev)}`);
            logger.error(`Ogmios error. ${String(ev)}`);
        }
        const closeHandler = ( ev: CloseEvent):any =>{
            const {code,reason}=ev; //https://www.rfc-editor.org/rfc/rfc6455#section-11.7
            const codeMsg=wsErrCodes[String(code)] || ""
            if(code===WS_ERR_NORMAL_CLOSURE){
                if(onNormalClose)
                    onNormalClose({code,reason,codeMsg});
                return;                
            }            
            //throw Error(`Ogmios error. WS connection closed. ${reason} (${code}:${codeMsg})`);
            logger.error(`Ogmios error. WS connection closed. ${reason} (${code}:${codeMsg})`);
            if(onAbnormalClose)
                onAbnormalClose({code,reason,codeMsg});
        }
        
        const initialErrorHandler = ( ev: Event):any =>{
            //logger.log({ev})
            //const {message}=ev;
            //reject (Error(`Ogmios error. ${message}`));
        }
        const initialCloseHandler = ( ev: CloseEvent):any =>{
            //logger.log({ev,client})
            const {code,reason}=ev; //https://www.rfc-editor.org/rfc/rfc6455#section-11.7
            if(code===WS_ERR_NORMAL_CLOSURE)
                return;
            const codeMsg=wsErrCodes[String(code)] || ""
            reject (Error(`Ogmios error. WS connection closed. ${reason} (${code}:${codeMsg})`));
        }

        const removeInitialListeners = ()=>{
            client.removeEventListener("error",initialErrorHandler);
            client.removeEventListener("close",initialCloseHandler);
        }
        const openHandler = ( ev: Event):any =>{
            removeInitialListeners();
            client.addEventListener("error",errorHandler);
            client.addEventListener("close",closeHandler);
            //conn close will gracefully release these ones??
            logger.info(`Cardano Ogmios API: connected OK.`); 
            resolve(client);
        }
        const addInitialListeners = ()=>{
            client.addEventListener("error",initialErrorHandler);
            client.addEventListener("close",initialCloseHandler);
            client.addEventListener("open",openHandler);
        }
        addInitialListeners();
    })
}


/**
 * Receives client (WebSocket) and the hexadecimal encoded signed transaction. 
 * TODO: Return the hash of the tx.
 * 
 * @param client 
 * @param txHex 
 */
export const submitTransaction= async (client:WebSocket,txHex:string):Promise<any>=>{

    return new Promise((resolve,reject)=>{
        let txHash:string=""
        try{
            if(!txHex)
                throw new Error("Missing transaction")            
            // txHash=getTxHashFromTxHex(txHex);
            // if(!txHash)
            //     throw new Error("Invalid transaction format")
        }catch(err){
            return resolve({
                result:"",
                errMessage:`Cannot submit.${err?.message||"unknown error"}`,
                message:"",
                code:""
            })
        }

        client.addEventListener("message", function(ev:any) {
            const data=ev?.data || {};
            const response = JSON.parse(data);
            logger.dir({submitTransaction:response},{depth:10});
            //logger.log({response});
            const{
                methodname,
                result,
                fault,
            }=response||{};
            //methodname: "SubmitTx"
            if(result==="SubmitSuccess"){
                return resolve({
                    result:{message:"OK",hash:txHash}
                })
            }
            if(fault?.code){
                return resolve({
                    //result:"",
                    errMessage:fault?.string,
                    message:"",
                    code:fault?.code
                })
            }
            if(result?.SubmitFail){
                return resolve(OgmiosErrList2ErrObj(result.SubmitFail))
                // let errCode:string="unknown";
                // try{errCode=Object.keys(result?.SubmitFail[0])[0]}catch(err){}
                // return resolve({
                //     //result:"",
                //     errMessage:` ${errCode} error`,
                //     message:"",
                //     code:errCode
                // })
            }
            return resolve({
                //result:"",
                errMessage:`unknown error`,
                message:"",
                code:""
            })
            //client.close();

        });
        const bytes=arrayBufferToBase64(Buffer.from(txHex,'hex'));
        wsp(client,"SubmitTx", { submit:bytes }); //old bytes property returns less info
    })
    
}



/**
 * Receives client (WebSocket) and the hexadecimal encoded signed transaction. 
 * TODO: Return the hash of the tx.
 * 
 * @param client 
 * @param txHex 
 */
export const evaluateTransaction= async (client:WebSocket,txHex:string):Promise<any>=>{

    return new Promise((resolve,reject)=>{
        let txHash:string=""
        try{
            if(!txHex)
                throw new Error("Missing transaction")                        
            // txHash=getTxHashFromTxHex(txHex);
            // if(!txHash)
            //     throw new Error("Invalid transaction format")
        }catch(err){
            //logger.error(err);
            return resolve({
                result:"",
                errMessage:`Cannot submit.${err?.message||"unknown error"}`,
                message:"",
                code:""
            })
        }

        client.addEventListener("message", function(ev:any) {
            const data=ev?.data || {};
            const response = JSON.parse(data);
            logger.dir({evaluateTransaction:response},{depth:10});
            const{
                methodname,
                result,
                fault,
            }=response||{};
            //methodname: "SubmitTx"
            if(result?.EvaluationResult){
                return resolve({
                    result:result?.EvaluationResult
                })
            }
            if(fault?.code){
                return resolve({
                    //result:"",
                    errMessage:fault?.string,
                    message:"",
                    code:fault?.code
                })
            }
            //seems it got renamed on newer ogmios versions
            if(result?.EvaluationFailure){
                return resolve(OgmiosErrList2ErrObj(result.EvaluationFailure))
            }
            //seems it was the old property name
            if(result?.EvaluationFail){
                return resolve(OgmiosErrList2ErrObj(result.EvaluationFail))
            }
            return resolve({
                //result:"",
                errMessage:`unknown error`,
                message:"",
                code:""
            })
            //client.close();

        });
        const bytes=arrayBufferToBase64(Buffer.from(txHex,'hex'));
        wsp(client,"EvaluateTx", { evaluate:bytes });
    })
    
}
