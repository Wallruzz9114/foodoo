import chai, { expect } from 'chai';
import chaiAsPromised from 'chai-as-promised';
import 'mocha';
import IAuthRepository from '../../auth/repositories/iAuthRepository';
import IPasswordService from '../../auth/services/iPasswordService';
import SignInUseCase from '../../auth/usecases/sign_in_usecase';
import FakePasswordService from './helpers/fakePasswordService';
import FakeRepository from './helpers/fakeRepository';

chai.use(chaiAsPromised);

describe('SignInUseCase', () => {
  let useCase: SignInUseCase;
  let repository: IAuthRepository;
  let passwordService: IPasswordService;

  const user = {
    id: '3278543',
    username: 'test_user123',
    email: 'test@user.com',
    password: 'LGDWIh9uergtu4eofgwc3pr8g03w8ty07ouwegf723940tr3owge',
  };

  beforeEach(() => {
    repository = new FakeRepository();
    passwordService = new FakePasswordService();
    useCase = new SignInUseCase(repository, passwordService);
  });

  it('should throw error when user is not found', async () => {
    const wrongUser = { email: 'wrongemail@test.com', password: '67828hafuo' };
    await expect(useCase.execute(wrongUser.email, wrongUser.password)).to.be.rejectedWith(
      'Invalid email or password'
    );
  });

  it('should return user id when email and password is correct', async () => {
    const id = await useCase.execute(user.email, user.password);
    expect(id).to.be.equal(user.id.toString());
  });
});
