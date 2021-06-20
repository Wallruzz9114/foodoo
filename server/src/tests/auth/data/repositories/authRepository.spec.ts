import { expect } from 'chai';
import dotenv from 'dotenv';
import mongoose from 'mongoose';
import AuthRepository from '../../../../auth/data/repositories/authRepository';

dotenv.config();

describe('AuthRepository', () => {
  let client: mongoose.Mongoose;
  let repository: AuthRepository;

  beforeEach(() => {
    client = new mongoose.Mongoose();
    const connectionString = encodeURI(process.env.TEST_DB as string);
    client.connect(connectionString, { useNewUrlParser: true, useUnifiedTopology: true });
    repository = new AuthRepository(client);
  });

  afterEach(() => {
    client.disconnect();
  });

  it('should return user when email is found', async () => {
    const email = 'test@user.com';
    const result = await repository.find(email);
    expect(result).to.not.be.empty;
  });

  it('should return a user id when successfully created', async () => {
    const newUser = {
      username: 'test_user3',
      email: 'test3@email.com',
      password: 'P@ssw0rd123!',
    };
    const result = await repository.add(newUser.username, newUser.email, newUser.password);
    expect(result).to.not.be.empty;
  });
});
