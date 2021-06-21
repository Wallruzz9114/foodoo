import IAuthRepository from '../../../auth/repositories/iAuthRepository';
import User from '../../../models/user';

export default class FakeRepository implements IAuthRepository {
  public users = [
    {
      id: '3278543',
      username: 'test_user123',
      email: 'test@user.com',
      password: 'LGDWIh9uergtu4eofgwc3pr8g03w8ty07ouwegf723940tr3owge',
    },
  ];

  public async find(email: string): Promise<User> {
    const user = this.users.find((x) => x.email === email);
    if (!user) return Promise.reject('Invalid email or password');
    return new User(user?.id, user?.username, user?.email, user?.password);
  }

  public async add(username: string, email: string, password: string): Promise<string> {
    const max = 9999;
    const min = 1000;
    const id = (Math.floor(Math.random() * (+max - +min)) + +min).toString();

    this.users.push({
      id: id,
      email: email,
      username: username,
      password: password,
    });

    return id;
  }
}
