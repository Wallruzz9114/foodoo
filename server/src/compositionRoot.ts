import mongoose from 'mongoose';
import redis from 'redis';
import AuthRepository from './auth/data/repositories/authRepository';
import PasswordService from './auth/data/services/passwordService';
import RedisService from './auth/data/services/redisService';
import TokenService from './auth/data/services/tokenService';
import AuthRouter from './auth/entrypoints/authRouter';
import TokenValidator from './auth/helpers/tokenValidator';

export default class CompositionRoot {
  private static _client: mongoose.Mongoose;
  private static _redisClient: redis.RedisClient;

  public static configure() {
    this._client = new mongoose.Mongoose();
    this._redisClient = redis.createClient();

    const connectionString = encodeURI(process.env.TEST_DB as string);

    this._client.connect(connectionString, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
  }

  public static authRouter() {
    const authRepository = new AuthRepository(this._client);
    const tokenService = new TokenService(process.env.PRIVATE_KEY as string);
    const passwordService = new PasswordService();
    const redisService = new RedisService(this._redisClient);
    const tokenValidator = new TokenValidator(tokenService, redisService);

    return AuthRouter.configure(
      authRepository,
      tokenService,
      passwordService,
      redisService,
      tokenValidator
    );
  }
}
