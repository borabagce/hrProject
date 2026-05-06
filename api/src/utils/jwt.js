import { SignJWT, jwtVerify } from 'jose';

const encode = (secret) => new TextEncoder().encode(secret);

const sign = (payload, secret, expiresIn) =>
  new SignJWT(payload)
    .setProtectedHeader({ alg: 'HS256' })
    .setIssuedAt()
    .setExpirationTime(expiresIn)
    .sign(encode(secret));

const verify = async (token, secret) => {
  const { payload } = await jwtVerify(token, encode(secret));
  return payload;
};

export const signAccessToken = (payload) =>
  sign(payload, process.env.JWT_SECRET, process.env.JWT_EXPIRES_IN);

export const signRefreshToken = (payload) =>
  sign(payload, process.env.JWT_REFRESH_SECRET, process.env.JWT_REFRESH_EXPIRES_IN);

export const verifyAccessToken = (token) =>
  verify(token, process.env.JWT_SECRET);

export const verifyRefreshToken = (token) =>
  verify(token, process.env.JWT_REFRESH_SECRET);
