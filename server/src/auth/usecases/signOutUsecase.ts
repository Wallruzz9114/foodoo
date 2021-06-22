import IRedisService from '../services/iRedisService';

export default class SignOutUsecase {
  public constructor(private readonly _redisService: IRedisService) {}

  public async execute(token: string): Promise<string> {
    this._redisService.save(token);
    return Promise.resolve('Successfully signed out');
  }
}
