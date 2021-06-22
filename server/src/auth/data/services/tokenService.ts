import jwt from 'jsonwebtoken';
import ITokenService from '../../services/iTokenService';

export default class TokenService implements ITokenService {
  public constructor(private readonly _privateKey: string) {}

  public encode(payload: string | object): string | object {
    const token = jwt.sign({ data: payload }, this._privateKey, {
      issuer: 'com.example.foodoo',
      expiresIn: '1h',
      algorithm: 'HS256',
    });

    return token;
  }

  public decode(token: string): string | object {
    try {
      const decodedToken = jwt.verify(token, this._privateKey);
      return decodedToken;
    } catch (error) {
      return 'Invalid token';
    }
  }
}
