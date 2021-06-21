import * as express from 'express';
import IAuthRepository from '../repositories/iAuthRepository';
import IPasswordService from '../services/iPasswordService';
import ITokenService from '../services/iTokenService';
import SignInUseCase from '../usecases/sign_in_usecase';
import AuthController from './authController';

export default class AuthRouter {
  public static configure(
    authRepository: IAuthRepository,
    tokenService: ITokenService,
    passwordService: IPasswordService
  ): express.Router {
    const router = express.Router();
    const authController = AuthRouter.createController(
      authRepository,
      tokenService,
      passwordService
    );

    router.post('/signin', (req, res) => authController.signIn(req, res));
    return router;
  }

  private static createController(
    authRepository: IAuthRepository,
    tokenService: ITokenService,
    passwordService: IPasswordService
  ): AuthController {
    const signInUseCase = new SignInUseCase(authRepository, passwordService);
    const authController = new AuthController(signInUseCase, tokenService);
    return authController;
  }
}
