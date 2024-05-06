import { Router } from 'express';
import { submitTx,evaluateTx } from '../controllers/cardano-ogmios';

const router = Router();

router.post('/submit_tx'	,submitTx);
router.post('/evaluate_tx'	,evaluateTx);

export default router;
