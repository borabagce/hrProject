import { User } from '../models/User.js';
import { Company } from '../models/Company.js';
import { signAccessToken, signRefreshToken, verifyRefreshToken } from '../utils/jwt.js';
import { ApiError } from '../utils/ApiError.js';

const tokenPayload = (user) => ({
  sub: user._id.toString(),
  companyId: user.companyId.toString(),
  role: user.role,
});

export const register = async (req, res, next) => {
  try {
    const { companyName, industry, fullName, email, password } = req.body;

    const existing = await User.findOne({ email });
    if (existing) throw ApiError.conflict('Email already registered');

    const company = await Company.create({ name: companyName, industry });
    const user = await User.create({
      companyId: company._id,
      fullName,
      email,
      passwordHash: password,
      role: 'admin',
    });

    const [accessToken, refreshToken] = await Promise.all([
      signAccessToken(tokenPayload(user)),
      signRefreshToken(tokenPayload(user)),
    ]);

    res.status(201).json({ success: true, data: { user, accessToken, refreshToken } });
  } catch (err) {
    next(err);
  }
};

export const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email, isActive: true }).select('+passwordHash');
    if (!user) throw ApiError.unauthorized('Invalid credentials');

    const match = await user.comparePassword(password);
    if (!match) throw ApiError.unauthorized('Invalid credentials');

    if (user.role === 'employee') throw ApiError.forbidden('Bu panele erişim yetkiniz yok.');

    const [accessToken, refreshToken] = await Promise.all([
      signAccessToken(tokenPayload(user)),
      signRefreshToken(tokenPayload(user)),
    ]);

    res.json({ success: true, data: { user, accessToken, refreshToken } });
  } catch (err) {
    next(err);
  }
};

export const mobileLogin = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email, isActive: true }).select('+passwordHash');
    if (!user) throw ApiError.unauthorized('Invalid credentials');

    const match = await user.comparePassword(password);
    if (!match) throw ApiError.unauthorized('Invalid credentials');

    if (user.role !== 'employee') {
      throw ApiError.forbidden('Bu uygulama yalnızca çalışanlar için ayrılmıştır.');
    }

    const [accessToken, refreshToken] = await Promise.all([
      signAccessToken(tokenPayload(user)),
      signRefreshToken(tokenPayload(user)),
    ]);

    res.json({ success: true, data: { user, accessToken, refreshToken } });
  } catch (err) {
    next(err);
  }
};

export const refreshToken = async (req, res, next) => {
  try {
    const { refreshToken: token } = req.body;
    if (!token) throw ApiError.badRequest('Refresh token required');

    let payload;
    try {
      payload = await verifyRefreshToken(token);
    } catch {
      throw ApiError.unauthorized('Invalid refresh token');
    }

    const user = await User.findById(payload.sub);
    if (!user || !user.isActive) throw ApiError.unauthorized();

    const [accessToken, newRefreshToken] = await Promise.all([
      signAccessToken(tokenPayload(user)),
      signRefreshToken(tokenPayload(user)),
    ]);

    res.json({ success: true, data: { accessToken, refreshToken: newRefreshToken } });
  } catch (err) {
    next(err);
  }
};

export const getMe = async (req, res) => {
  res.json({ success: true, data: req.user });
};
