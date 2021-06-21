import IAuthRepository from '../repositories/iAuthRepository';
import IPasswordService from '../services/iPasswordService';

export default class SignInUseCase {
  public constructor(
    private _authRepository: IAuthRepository,
    private _passwordService: IPasswordService
  ) {}

  public async execute(email: string, password: string): Promise<string> {
    if (this.passwordIsValid(password)) {
      const user = await this._authRepository.find(email);
      if (!(await this._passwordService.compare(password, user.password))) {
        return Promise.reject('Invalid email or password');
      }
      return user.id;
    }
    return 'Error while signing in.';
  }

  private passwordIsValid(password: string): boolean {
    return password.length > 6;
  }
}
