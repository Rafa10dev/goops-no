import express from 'express';
import healthRouter from './routes/health.route.js'
import authRouter from './routes/auth.route.js';
import errorHandler from "./middlewares/error-handler.js";


const app = express();

app.use(express.json());

app.use('/health', healthRouter);
app.use('/auth', authRouter)

app.use(errorHandler);

export default app;

