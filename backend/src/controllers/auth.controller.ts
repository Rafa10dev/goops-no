import type { Request, Response } from "express";
import { loginSchema, registerSchema } from "../schemas/auth.schema.js"
import { loginUser, registerUser } from "../services/auth.service.js";
import { generateAccessToken } from "../services/token.service.js";

export const register = async (req: Request, res: Response) => {
    const data = registerSchema.parse(req.body);

    const user = await registerUser(data);

    return res.status(201).json({
        message: "Usuário criado com sucesso",
        user
    });
}

export const login = async (req: Request, res: Response) => {
    const data = loginSchema.parse(req.body);

    const user = await loginUser(data);

    const token = generateAccessToken({
        sub: user.id,
        role: user.role
    });

    return res.status(200).json({
        message: "Login realizado com sucesso",
        user,
        token
    });
}