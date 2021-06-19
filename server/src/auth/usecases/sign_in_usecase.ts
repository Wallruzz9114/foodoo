import IAuthRepository from '../repositories/iAuthRepository';
import IPasswordService from '../services/iPasswordService';

export default class SignInUseCase {
  constructor(private authRepository: IAuthRepository, private passwordService: IPasswordService) {}

  public async execute(email: string, password: string): Promise<string> {
    if (this.passwordIsValid(password)) {
      const user = await this.authRepository.find(email);
      if (!(await this.passwordService.compare(password, user.password))) {
        return Promise.reject('User not found');
      }
      return user.id.toString();
    }
    return 'Error while signing in.';
  }

  private passwordIsValid(password: string): boolean {
    return password.length > 6;
  }
}
