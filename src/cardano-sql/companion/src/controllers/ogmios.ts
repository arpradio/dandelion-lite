import { Request, Response } from 'express';
import {submitTxFromCbor,evaluateTxFromCbor} from '../services/ogmios';

export const submitTx = async (req: Request, res: Response) => {
  const {
    txHex
  } = req.body;

  if (!txHex) {
    return res.status(400).json({
	field:"txHex",
	message:"cannot be empty. Must contain a valid signed transaction CBOR as hexadecimal string"});
  }
  console.dir({submitTx:req.body});

  const result=await submitTxFromCbor(txHex);
 
  return res.status(200).json(JSON.parse(result));

  /*return res.status(200).json({
    message: `Transaction '${txHex}' has been submitted`,
    txHex,
  });*/
};


export const evaluateTx = async (req: Request, res: Response) => {
  const {
    txHex
  } = req.body;

  if (!txHex) {
    return res.status(400).json({
        field:"txHex",
        message:"cannot be empty. Must contain a valid signed transaction CBOR as hexadecimal string"});
  }
  
  console.dir({evaluateTx:req.body});
  const result=await evaluateTxFromCbor(txHex);
 
  return res.status(200).json(JSON.parse(result));

  /*return res.status(200).json({
    message: `Transaction '${txHex}' has been evaluated`,
    txHex,
  });*/
};
