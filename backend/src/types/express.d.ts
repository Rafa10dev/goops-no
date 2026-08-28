import { accessTokenSchema } from "../schemas/auth.schema.js";

type AuthUser = ReturnType<typeof accessTokenSchema.parse>;

declare global {
    namespace Express {
        interface Request {
            user?: AuthUser;
        }
    }
}

export default AuthUser;