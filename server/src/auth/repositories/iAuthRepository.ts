import User from 'src/models/user';

export default interface IAuthRepository {
  find(email: string): Promise<User>;
  add(username: string, email: string, passwordHash: string): Promise<string>;
}
