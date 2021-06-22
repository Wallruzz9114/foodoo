import IAuthRepository from '../repositories/iAuthRepository';
import IPasswordService from '../services/iPasswordService';

export default class SignUpUsecase {
  constructor(private authRepository: IAuthRepository, private passwordService: IPasswordService) {}

  public async execute(username: string, email: string, password: string): Promise<string> {
    const user = await this.authRepository.find(email).catch((_) => null);

    if (user) return Promise.reject('User already exists');

    const passwordHash = password ? await this.passwordService.hash(password) : undefined;
    const userId = await this.authRepository.add(username, email, passwordHash);

    return userId;
  }
}
