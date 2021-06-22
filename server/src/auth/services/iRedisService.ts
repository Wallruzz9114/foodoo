export default interface IRedisService {
  save(token: string): void;
  get(token: string): Promise<string>;
}
