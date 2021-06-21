import * as express from 'express';
import ITokenService from '../services/iTokenService';
import SignInUseCase from '../usecases/sign_in_usecase';
import { SignInInput } from './../data/models/signInInput';

export default class AuthController {
  private readonly _signInUseCase: SignInUseCase;
  private readonly _tokenService: ITokenService;

  public constructor(signInUseCase: SignInUseCase, tokenService: ITokenService) {
    this._signInUseCase = signInUseCase;
    this._tokenService = tokenService;
  }

  public async signIn(req: express.Request, res: express.Response) {
    try {
      const { email, password }: SignInInput = req.body;

      return this._signInUseCase
        .execute(email, password)
        .then((id: string) => res.status(200).json({ auth_token: this._tokenService.encode(id) }))
        .catch((error: Error) => res.status(404).json({ error: error.message }));
    } catch (error) {
      return res.status(400).json({ error: error });
    }
  }
}
