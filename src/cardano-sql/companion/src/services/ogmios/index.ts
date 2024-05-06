// Based on https://github.com/WingRiders/on-chain-dao-governance/blob/main/backend/src/ogmios/ogmios.ts
// Currently failing (hangs) with latest ogmios + node, maybe due to https://github.com/CardanoSolutions/ogmios/issues/363
// My implementation works, and replies on SubmitTx even if node is not 100% in sync. EvaluateTx is hanging (not tried with node at tip yet)

import {txSubmissionClient} from './txSubmissionClient'
export * from './context'

export const arrayBufferToBase64=( buffer:Buffer )=> {
  var binary = '';
  var bytes = new Uint8Array( buffer );
  var len = bytes.byteLength;
  for (var i = 0; i < len; i++) {
      binary += String.fromCharCode( bytes[ i ] );
  }
  //return window.btoa( binary );
  return btoa( binary );
}

export async function evaluateTxFromCbor(txHex: string): Promise<string> {  
  if (!txSubmissionClient) {
    throw new Error('Ogmios client is not initialized')
  }
  try {    
    const txBase64= arrayBufferToBase64(Buffer.from(txHex,'hex'))
    console.log({submitTx:{txHex,txBase64}})
    const ogmiosReply = await txSubmissionClient.evaluateTransaction(txBase64)
    console.log({evaluateTx:{ogmiosReply}})
    return JSON.stringify(ogmiosReply)
  } catch (e) {
    console.error(e, txHex)
    throw e
  }
}



export async function submitTxFromCbor(txHex: string): Promise<string> {  
  if (!txSubmissionClient) {
    throw new Error('Ogmios client is not initialized')
  }    
  try {    
    const txBase64= arrayBufferToBase64(Buffer.from(txHex,'hex'))
    console.log({submitTx:{txHex,txBase64}})
    const ogmiosReply = await txSubmissionClient.submitTransaction(txBase64)
    console.log({submitTx:{ogmiosReply}})
    return JSON.stringify(ogmiosReply)
  } catch (e) {
    console.error(e, txHex)
    throw e
  }
}
