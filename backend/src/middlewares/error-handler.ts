import type { ErrorRequestHandler } from "express";
import { AppError } from "../errors/AppError.js";

const errorHandler: ErrorRequestHandler = (
    error,
    req,
    res,
    next,
) => {
    if (error instanceof AppError) {
        return res.status(error.statusCode).json({
            status: error.statusCode,
            message: error.message,
        });
    }

    console.error(error);

    return res.status(500).json({
        status: 500,
        message: "Erro interno do servidor",
    });
};

export default errorHandler;