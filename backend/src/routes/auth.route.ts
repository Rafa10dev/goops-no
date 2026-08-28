import { Router } from "express";
import { register, login } from "../controllers/auth.controller.js";
import { asyncHandler } from "../utils/async-handler.js";

const authRouter = Router();

authRouter.post('/register', asyncHandler(register));
authRouter.post("/login", asyncHandler(login));


export default authRouter;