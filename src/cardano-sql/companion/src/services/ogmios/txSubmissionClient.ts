import {
  InteractionContext,
  TransactionSubmission,
  createTransactionSubmissionClient,
} from '@cardano-ogmios/client'


export let txSubmissionClient: TransactionSubmission.TransactionSubmissionClient | null

export const initializeTxSubmissionClient = async (context: InteractionContext) => {
  if (!txSubmissionClient) {
    txSubmissionClient = await createTransactionSubmissionClient(context)
    console.dir({txSubmissionClientCreated:txSubmissionClient});
  }
  console.log('Ogmios tx submission client initialized.')
}

export const isTxSubmissionReady = () => !!txSubmissionClient

export const shutDownTxSubmissionClient = async () => {
  if (txSubmissionClient) {
    console.log('Ogmios tx submission client shutting down..')
    await txSubmissionClient.shutdown()
  }
}

export const closeTxSubmissionClient = () => {
  console.log('Ogmios tx submission client closing..')
  txSubmissionClient = null
}
