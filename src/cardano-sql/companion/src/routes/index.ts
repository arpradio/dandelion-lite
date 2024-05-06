import { Router } from 'express';
import ogmiosRoutes from './cardano-ogmios';
import infoRoutes from './info';

const router = Router();

router.use('/ogmios', ogmiosRoutes);
router.use('/info', infoRoutes);

export default router;
