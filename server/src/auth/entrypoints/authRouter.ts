import * as express from 'express';
import TokenValidator from '../helpers/tokenValidator';
import IAuthRepository from '../repositories/iAuthRepository';
import IPasswordService from '../services/iPasswordService';
import IRedisService from '../services/iRedisService';
import ITokenService from '../services/iTokenService';
import SignInUsecase from '../usecases/signInUsecase';
import SignOutUsecase from '../usecases/signOutUsecase';
import SignUpUsecase from '../usecases/signUpUsecase';
import { signUpValidationRules, validate } from './../helpers/validators';
import AuthController from './authController';

export default class AuthRouter {
  public static configure(
    authRepository: IAuthRepository,
    tokenService: ITokenService,
    passwordService: IPasswordService,
    redisService: IRedisService,
    tokenValidator: TokenValidator
  ): express.Router {
    const router = express.Router();
    const authController = AuthRouter.createController(
      authRepository,
      tokenService,
      passwordService,
      redisService
    );

    router.post('/signin', (req, res) => authController.signIn(req, res));
    router.post(
      '/signup',
      signUpValidationRules(),
      validate,
      (req: express.Request, res: express.Response) => authController.signUp(req, res)
    );
    router.post(
      '/signout',
      (req, res, next) => tokenValidator.validate(req, res, next),
      (req: express.Request, res: express.Response) => authController.signOut(req, res)
    );

    return router;
  }

  private static createController(
    authRepository: IAuthRepository,
    tokenService: ITokenService,
    passwordService: IPasswordService,
    redisService: IRedisService
  ): AuthController {
    const signInUseCase = new SignInUsecase(authRepository, passwordService);
    const signUpUseCase = new SignUpUsecase(authRepository, passwordService);
    const signOutUsecase = new SignOutUsecase(redisService);
    const authController = new AuthController(
      signInUseCase,
      signUpUseCase,
      signOutUsecase,
      tokenService
    );
    return authController;
  }
}
