import { Router } from "express";

const healthRouter = Router();

healthRouter.get('/', (req, res) => {
    res.status(200).json({
        status: 'OK',
        message: 'GoOps NO API is running'
    });
})

export default healthRouter;