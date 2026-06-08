import mongoose from 'mongoose';

const CONNECTION_OPTIONS = {
  maxPoolSize: 20,
  minPoolSize: 2,
  serverSelectionTimeoutMS: 5000,
  socketTimeoutMS: 45000,
};

export const connectDB = async () => {
  const conn = await mongoose.connect(process.env.MONGODB_URI, CONNECTION_OPTIONS);
  console.log(`MongoDB connected: ${conn.connection.host}`);
};

export const disconnectDB = () => mongoose.disconnect();
