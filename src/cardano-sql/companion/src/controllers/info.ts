import { Request, Response } from 'express';
import { getConfig } from '../config';



export const manifest = async (req: Request, res: Response) => {
    const config=await getConfig();
    res.status(200).json(config.info.manifest);
};

