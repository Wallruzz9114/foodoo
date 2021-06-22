import { expect } from 'chai';
import express from 'express';
import redis from 'redis';
import RedisService from 'src/auth/data/services/redisService';
import request from 'supertest';
import PasswordService from '../../../auth/data/services/passwordService';
import TokenService from '../../../auth/data/services/tokenService';
import AuthRouter from '../../../auth/entrypoints/authRouter';
import TokenValidator from '../../../auth/helpers/tokenValidator';
import IAuthRepository from '../../../auth/repositories/iAuthRepository';
import FakeRepository from '../helpers/fakeRepository';

describe('AuthRouter', () => {
  let authRepository: IAuthRepository;
  let app: express.Application;

  const user = {
    email: 'baller@gg.com',
    id: '1234',
    name: 'Ken',
    password: 'pass',
  };

  beforeEach(() => {
    authRepository = new FakeRepository();
    const tokenService = new TokenService('randomPrivateKey');
    const passwordService = new PasswordService();
    const redisClient = redis.createClient();
    const redisService = new RedisService(redisClient);
    const tokenValidator = new TokenValidator(tokenService, redisService);
    const router = AuthRouter.configure(
      authRepository,
      tokenService,
      passwordService,
      redisService,
      tokenValidator
    );

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

  it('should return 200 and token when user is found', async () => {
    await request(app)
      .post('/auth/signin')
      .send({ email: user.email, password: user.password })
      .set('Accept', 'application/json')
      .expect('Content-type', /json/)
      .expect(200)
      .then((res) => {
        expect(res.body.auth_token).to.not.be.empty;
      });
  });

  it('should return errors', async () => {
    //act
    await request(app)
      .post('/auth/signup')
      .send({ email: '', password: user.password, auth_type: 'email' })
      .set('Accept', 'application/json')
      .expect('Content-Type', /json/)
      .expect(422)
      .then((res) => {
        expect(res.body.errors).to.not.be.empty;
      });
  });

  it('should create user and return token', async () => {
    let email = 'my@email.com';
    let name = 'test user';
    let password = 'pass123';
    let type = 'email';

    await request(app)
      .post('/auth/signup')
      .send({ email: email, password: password, auth_type: type, name: name })
      .set('Accept', 'application/json')
      .expect('Content-type', /json/)
      .expect(200)
      .then((res) => {
        expect(res.body.auth_token).to.not.be.empty;
      });
  });
});
