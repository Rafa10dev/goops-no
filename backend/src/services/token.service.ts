import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET;

if (!JWT_SECRET) {
  throw new Error("JWT_SECRET não configurado");
}

type AccessTokenPayload = {
  sub: number;
  role: "OPERATOR" | "ADMIN";
};

export const generateAccessToken = (payload: AccessTokenPayload) => {
  return jwt.sign(payload, JWT_SECRET, {
    expiresIn: "12h",
  });
};