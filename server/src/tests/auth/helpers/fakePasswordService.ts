import IPasswordService from 'src/auth/services/iPasswordService';

export default class FakePasswordService implements IPasswordService {
  public async hash(password: string): Promise<string> {
    return password;
  }
  public async compare(password: string, hash: string): Promise<boolean> {
    return password == hash;
  }
}
