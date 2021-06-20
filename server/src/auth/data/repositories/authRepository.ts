import { Mongoose } from 'mongoose';
import IAuthRepository from '../../../auth/repositories/iAuthRepository';
import User from '../../../models/user';
import { UserModel, UserSchema } from './../models/userModel';

export default class AuthRepository implements IAuthRepository {
  constructor(private readonly client: Mongoose) {}

  public async find(email: string): Promise<User> {
    const users = this.client.model<UserModel>('user', UserSchema);
    const user = await users.findOne({ email: email });
    if (!user) return Promise.reject('Invalid email or password');

    return new User(user.id, user.username, user.email, user.password);
  }

  public async add(username: string, email: string, passwordHash: string): Promise<string> {
    const userModel = this.client.model<UserModel>('user', UserSchema);
    const newUser = await userModel.create({
      username: username,
      email: email,
      password: passwordHash,
    });

    return newUser.id;
  }
}
