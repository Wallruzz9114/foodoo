import bcrypt from 'bcrypt';
import IPasswordService from '../../services/iPasswordService';

export default class PasswordService implements IPasswordService {
  public constructor(private readonly _saltRounds: number = 10) {}

  public hash(password: string): Promise<string> {
    return bcrypt.hash(password, this._saltRounds);
  }

  public compare(password: string, hash: string): Promise<boolean> {
    return bcrypt.compare(password, hash);
  }
}
