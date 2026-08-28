import type { NextFunction, Request, Response } from "express";
import { AppError } from "../errors/AppError.js";

type UserRole = "OPERATOR" | "ADMIN";

export const authorize = (...allowedRoles: UserRole[]) => {
    return (
        req: Request,
        res: Response,
        next: NextFunction,
    ) => {
        if (!req.user) {
            throw new AppError("Usuário não autenticado", 401);
        }

        if (!allowedRoles.includes(req.user.role)) {
            throw new AppError("Acesso negado", 403);
        }

        next();
    };
};