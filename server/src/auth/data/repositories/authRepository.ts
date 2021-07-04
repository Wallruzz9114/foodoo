import { Mongoose } from 'mongoose';
import IAuthRepository from '../../../auth/repositories/iAuthRepository';
import User from '../../../models/user';
import { IUserModel, UserSchema } from './../models/userModel';

export default class AuthRepository implements IAuthRepository {
  public constructor(private readonly _client: Mongoose) {}

  public async find(username: string): Promise<User> {
    const users = this._client.model<IUserModel>('user', UserSchema);
    const user = await users.findOne({ username: username.toLowerCase() });
    if (!user) return Promise.reject('User not found');

    return new User(user.id, user.username, user.email, user.password ?? '');
  }

  public async add(username: string, email: string, passwordHash: string): Promise<string> {
    const userModel = this._client.model<IUserModel>('user', UserSchema);
    const newUser = new userModel({
      username: username,
      email: email,
      password: passwordHash,
    });

    if (passwordHash) newUser.password = passwordHash;

    newUser.save();
    return newUser.id;
  }
}
