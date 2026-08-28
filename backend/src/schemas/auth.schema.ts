import z from "zod"

export const registerSchema = z.object({
    name: z.string().min(2, "Nome deve ter pelo menos 2 caracteres"),
    email: z.email("Email inválido"),
    password: z.string().min(6, "Senha deve ter pelo menos 6 caracteres")
})

export const loginSchema = z.object({
  email: z.email("Email inválido"),
  password: z.string().min(1, "Senha é obrigatória"),
});

export const accessTokenSchema = z.object({
    sub: z.number(),
    role: z.enum(["OPERATOR", "ADMIN"]),
});