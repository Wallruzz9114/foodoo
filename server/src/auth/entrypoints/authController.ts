import * as express from 'express';
import { SignUpInput } from '../data/models/signUpInput';
import ITokenService from '../services/iTokenService';
import SignInUsecase from '../usecases/signInUsecase';
import SignOutUsecase from '../usecases/signOutUsecase';
import SignUpUsecase from '../usecases/signUpUsecase';
import { SignInInput } from './../data/models/signInInput';

export default class AuthController {
  private readonly _signInUseCase: SignInUsecase;
  private readonly _signUpUseCase: SignUpUsecase;
  private readonly _signOutUsecase: SignOutUsecase;
  private readonly _tokenService: ITokenService;

  public constructor(
    signInUseCase: SignInUsecase,
    signUpUseCase: SignUpUsecase,
    signOutUsecase: SignOutUsecase,
    tokenService: ITokenService
  ) {
    this._signInUseCase = signInUseCase;
    this._signUpUseCase = signUpUseCase;
    this._signOutUsecase = signOutUsecase;
    this._tokenService = tokenService;
  }

  public async signIn(req: express.Request, res: express.Response) {
    try {
      const { username, password }: SignInInput = req.body;

      return this._signInUseCase
        .execute(username, password)
        .then((id: string) => res.status(200).json({ auth_token: this._tokenService.encode(id) }))
        .catch((error: Error) => res.status(404).json({ error: error }));
    } catch (error) {
      return res.status(400).json({ error: error });
    }
  }

  public async signUp(req: express.Request, res: express.Response) {
    try {
      const { username, email, password }: SignUpInput = req.body;

      return this._signUpUseCase
        .execute(username, email, password)
        .then((id: string) => res.status(200).json({ auth_token: this._tokenService.encode(id) }))
        .catch((error: Error) => res.status(404).json({ error: error }));
    } catch (error) {
      return res.status(400).json({ error: error });
    }
  }

  public async signOut(req: express.Request, res: express.Response) {
    try {
      const token = req.headers.authorization as string;

      return this._signOutUsecase
        .execute(token)
        .then((result: string) => res.status(200).json({ message: result }))
        .catch((error: Error) => res.status(404).json({ error: error }));
    } catch (error) {
      return res.status(400).json({ error: error });
    }
  }
}
