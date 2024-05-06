import { Router } from 'express';
import { manifest } from '../controllers/info';

const router = Router();

router.get('/manifest'	,manifest);

export default router;
