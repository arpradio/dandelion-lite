import { createInteractionContext, InteractionContext } from '@cardano-ogmios/client'
import { getConfig } from '../../config';
import {
	isTxSubmissionReady,
	closeTxSubmissionClient,
	shutDownTxSubmissionClient,
	initializeTxSubmissionClient,
} from './txSubmissionClient';


export function sleep<T>(ms, value?: T): Promise<T | undefined> {
  return new Promise((resolve) => setTimeout(() => resolve(value), ms))
}



export const ogmiosInitParams={
    isReadyFn: () => {
      return isTxSubmissionReady()// && isStateQueryReady()
    },
    closeClientsFn: () => {
      closeTxSubmissionClient()
      //closeStateQueryClient()
    },
    shutdownFn: async () => {
      await shutDownTxSubmissionClient()
      //await shutDownStateQueryClient()
    },
    initializeClientsFn: async (context: InteractionContext) => {
      await initializeTxSubmissionClient(context)
      //await initializeStateQueryClient(context)
    },
  }





const initInteractionContext = (connection,closeClientsFn: () => void): Promise<InteractionContext> =>
  createInteractionContext(
    (err) => {
      throw err
    },
    () => {
      closeClientsFn()
      console.error('Ogmios Client connection closed.')
    },
    {
      connection,
    }
);

export const ogmiosClientInitializerLoop = async () => {
  const config=await getConfig();
  console.info('Starting ogmios client initializer loop')
  
  // eslint-disable-next-line no-constant-condition
  while (true) {
    if (!ogmiosInitParams.isReadyFn()) {
      try {
        const context = await initInteractionContext(config.ogmios.connection, ogmiosInitParams.closeClientsFn)
        await ogmiosInitParams.initializeClientsFn(context)
      } catch (e) {
        console.error(e, 'Failed to initialize Ogmios clients, retrying in 20 seconds')
      }
    }
    // eslint-disable-next-line no-await-in-loop
    await sleep(20_000)
  }
}


type ExitOptions = {
  caller?: string
  exit?: boolean
}

const onExit = (options: ExitOptions) => async () => {
  console.info('Cleaning the APP')
  try {
    await ogmiosInitParams.shutdownFn()
    console.info(`Stopped sync (${options.caller})`)
    if (options.exit) {
      process.exit()
    }
  } catch (e) {
    console.error(e)
  }
}

export function registerCleanUp() {
  // do something when app is closing
  process.on('exit', onExit({caller: 'exit'}))

  // catches ctrl+c event
  process.on('SIGINT', onExit({caller: 'SIGINT', exit: true}))

  // catches "kill pid" (for example: nodemon restart)
  process.on('SIGUSR1', onExit({exit: true}))
  process.on('SIGUSR2', onExit({caller: 'SIGUSR2', exit: true}))
}
