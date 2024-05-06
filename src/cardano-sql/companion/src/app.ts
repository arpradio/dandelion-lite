import express from 'express';
import cors from 'cors';
import routes from './routes';
import {ogmiosClientInitializerLoop,registerCleanUp} from './services/ogmios';
import { getConfig } from './config';

const app = express();

const start = async () => {
	const config=await getConfig();
	console.dir({config},{depth:10});

	//ogmiosClientInitializerLoop()
	//registerCleanUp()
	
	if(config.cors)
		app.use(cors());

	app.use(express.json());
	app.use((req, res, next) => {
		res.setTimeout(config.timeout, ()=>{
			console.log('Request has timed out.');
			res.sendStatus(408);
		});
		next();
	});
	app.use('/', routes);

	app.listen(config.port, () => {
		console.log(`Cardano-SQL Companion Service running on port ${config.port}`);
	});
	
}

start();

export default app;
