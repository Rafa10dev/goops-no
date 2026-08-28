import type { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";

import { accessTokenSchema } from "../schemas/auth.schema.js";
import { AppError } from "../errors/AppError.js";

const JWT_SECRET = process.env.JWT_SECRET;

if (!JWT_SECRET) {
    throw new Error("JWT_SECRET não configurado");
}

export const authenticate = (
    req: Request,
    res: Response,
    next: NextFunction,
) => {
    const authorization = req.headers.authorization;

    if (!authorization) {
        throw new AppError("Token não fornecido", 401);
    }

    const [type, token] = authorization.split(" ");

    if (type !== "Bearer" || !token) {
        throw new AppError("Token inválido", 401);
    }

    try {
        const decoded = jwt.verify(token, JWT_SECRET);

        const payload = accessTokenSchema.parse(decoded);

        req.user = payload;

        next();
    } catch {
        throw new AppError("Token inválido ou expirado", 401);
    }
};