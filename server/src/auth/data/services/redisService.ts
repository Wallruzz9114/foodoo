import { RedisClient } from 'redis';
import { promisify } from 'util';
import IRedisService from '../../../auth/services/iRedisService';

export default class RedisService implements IRedisService {
  public constructor(private readonly _client: RedisClient) {}

  public save(token: string): void {
    this._client.set(token, token);
  }

  public async get(token: string): Promise<string> {
    const getAsync = promisify(this._client.get).bind(this._client);
    const res = await getAsync(token);
    return res ?? '';
  }
}
