import express from 'express';
import request from 'supertest';
import PasswordService from '../../../auth/data/services/passwordService';
import TokenService from '../../../auth/data/services/tokenService';
import AuthRouter from '../../../auth/entrypoints/authRouter';
import IAuthRepository from '../../../auth/repositories/iAuthRepository';
import FakeRepository from '../helpers/fakeRepository';

describe('AuthRouter', () => {
  let repository: IAuthRepository;
  let app: express.Application;

  beforeEach(() => {
    repository = new FakeRepository();
    const tokenService = new TokenService('randomPrivateKey');
    const passwordService = new PasswordService();
    const router = AuthRouter.configure(repository, tokenService, passwordService);

    app = express();

    app.use(express.json());
    app.use(express.urlencoded({ extended: true }));
    app.use('/auth', router);
  });

  it('should return 404 when user is not found', async () => {
    const wrongUser = {
      email: 'wrongemail@gg.com',
      id: '1234',
      name: 'Ken',
      password: 'pass123',
    };
    await request(app).post('/auth/signin').send(wrongUser).expect(404);
  });
});
