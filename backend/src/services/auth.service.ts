import prisma from "../lib/prisma.js";
import bcrypt from "bcrypt";
import { AppError } from "../errors/AppError.js";

type RegisterData = {
    name: string;
    email: string;
    password:string;
}

type LoginData = {
    email: string;
    password: string;
}

export const registerUser = async (data: RegisterData) => {
    const existingUser = await prisma.user.findUnique({
        where: { email: data.email },
    });

    if(existingUser){
        throw new AppError("Email já cadastrado", 409)
    }

    const hashedPassword = await bcrypt.hash(data.password, 12);

    const user = await prisma.user.create({
        data: {
            name: data.name,
            email: data.email,
            password: hashedPassword
        },
    });

    return {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role
    };
}

export const loginUser = async (data: LoginData) => {
    const user = await prisma.user.findUnique({
        where: {
            email: data.email
        },
    });

    if(!user){
        throw new AppError("Email ou senha inválidos", 401)
    }

    const passwordMatches = await bcrypt.compare(
        data.password,
        user.password
    )

     if (!passwordMatches) {
        throw new AppError("Email ou senha inválidos", 401);
    }

    return {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
    };
}