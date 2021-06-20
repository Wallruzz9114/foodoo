import * as mongoose from 'mongoose';

export interface UserModel extends mongoose.Document {
  username: string;
  email: string;
  password: string;
}

export const UserSchema = new mongoose.Schema({
  username: { type: String, required: true },
  email: { type: String, required: true },
  password: { type: String, required: true },
});
