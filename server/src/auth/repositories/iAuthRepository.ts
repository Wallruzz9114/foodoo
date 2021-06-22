import User from '../../models/user';

export default interface IAuthRepository {
  find(username: string): Promise<User>;
  add(username: string, email: string, passwordHash: string | undefined): Promise<string>;
}
