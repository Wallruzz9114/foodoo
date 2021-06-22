import { NextFunction, Request, Response } from 'express';
import IRedisService from '../services/iRedisService';
import ITokenService from '../services/iTokenService';

export default class TokenValidator {
  public constructor(
    private readonly _tokenService: ITokenService,
    private readonly _redisService: IRedisService
  ) {}

  public async validate(req: Request, res: Response, next: NextFunction) {
    const authHeader = req.headers.authorization;

    if (!authHeader) return res.status(401).json({ error: 'Authorization header required' });

    const decodedToken = this._tokenService.decode(authHeader);
    const cachedToken = await this._redisService.get(authHeader);

    if (decodedToken === '' || cachedToken !== '')
      return res.status(403).json({ error: 'Invalid token' });

    next();
    return;
  }
}
