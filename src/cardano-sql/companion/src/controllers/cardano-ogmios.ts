// IMPORTANT: Ogmios v6.1.* is not supported by this controller. Cardano SQL Ogmios schema has up-to-date direct postgres->ogmios support now.
//            Use this code and REST API when using old ogmios versions or update cardano-sql ogmios schema to support them

import { Request, Response } from 'express';
import { getConfig } from '../config';
import { startCardanoOgmiosClient,submitTransaction,evaluateTransaction } from '../services/cardano-ogmios';

let client:WebSocket;

const initClient=async(res:Response)=>{
  if(client)
    return;
  console.info(`Starting websocket connection on demand...`)
  const config=await getConfig();
  const uri=`ws://${config.ogmios.connection.host}:${config.ogmios.connection.port}`
  try{    
    client =await startCardanoOgmiosClient(uri,'',{
      onNormalClose:async ()=>{
        client=undefined;
      },
      onAbnormalClose:async ()=>{
        client=undefined;
      }
    });      
    if(!client)
      throw new Error("Unknown connection error")
  }catch(err){
    return res.status(500).json({
          message:err?.message||"Unknown error"})
  }    
  
}
  


export const submitTx = async (req: Request, res: Response) => {
  const {
    txHex
  } = req.body;

  if (!txHex) {
    return res.status(400).json({
      field:"txHex",
      message:"cannot be empty. Must contain a valid signed transaction CBOR as hexadecimal string"
    });
  }
  //console.dir({submitTx:req.body});
  await initClient(res);
  try{
    const result=await submitTransaction(client,txHex); 
    //console.dir({submitTx:result});
    return res.status(200).json(result);
  }catch(err){
    return res.status(500).json({
          message:err?.message||"Unknown error"
    });
  }
};


export const evaluateTx = async (req: Request, res: Response) => {
  const {
    txHex
  } = req.body;

  if (!txHex) {
    return res.status(400).json({
      field:"txHex",
      message:"cannot be empty. Must contain a valid signed transaction CBOR as hexadecimal string"
    });
  }
  //console.dir({evaluateTx:req.body});
  await initClient(res);
  try{
    const result=await evaluateTransaction(client,txHex); 
    //console.dir({evaluateTx:result});
    return res.status(200).json(result);
  }catch(err){
    return res.status(500).json({
          message:err?.message||"Unknown error"
    });
  }
};
