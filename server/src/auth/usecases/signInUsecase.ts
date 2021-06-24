import IAuthRepository from '../repositories/iAuthRepository';
import IPasswordService from '../services/iPasswordService';

export default class SignInUsecase {
  public constructor(
    private _authRepository: IAuthRepository,
    private _passwordService: IPasswordService
  ) {}

  public async execute(username: string, password: string): Promise<string> {
    const user = await this._authRepository.find(username).catch((_) => null);
    if (!user || !(await this._passwordService.compare(password, user.password)))
      return Promise.reject('Invalid username or password');

    return user.id;
  }
}
