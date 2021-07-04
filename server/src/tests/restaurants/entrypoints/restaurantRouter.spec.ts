import { expect } from 'chai';
import dotenv from 'dotenv';
import express from 'express';
import mongoose from 'mongoose';
import IRedisService from 'src/auth/services/iRedisService';
import ITokenService from 'src/auth/services/iTokenService';
import request from 'supertest';
import TokenValidator from '../../../auth/helpers/tokenValidator';
import { cleanupDb, setupDb } from '../../../restaurant/data/helpers/helpers';
import RestaurantRouter from '../../../restaurant/entrypoints/restaurantRouter';
import IRestaurantRepository from '../../../restaurant/repositories/iRestaurantRepository';
import { IRestaurantDoc } from './../../../restaurant/data/models/restaurantModel';
import { RestaurantRepository } from './../../../restaurant/data/repositories/restaurantRepository';

dotenv.config();

describe('RestaurantRouter', () => {
  let repository: IRestaurantRepository;
  let app: express.Application;

  let client: mongoose.Mongoose;
  let savedRestaurants: IRestaurantDoc[] = [];

  before(() => {
    client = new mongoose.Mongoose();

    const connectionStr = encodeURI(process.env.TEST_DB as string);
    client.connect(connectionStr, {
      useNewUrlParser: true,
      useCreateIndex: true,
      useUnifiedTopology: true,
    });
    repository = new RestaurantRepository(client);
    let tokenService = new FakeTokenService();
    let tokenStore = new FakeTokenStore();

    app = express();
    app.use(express.json());
    app.use(express.urlencoded({ extended: true }));
    app.use(
      '/restaurants',
      RestaurantRouter.configure(repository, new TokenValidator(tokenService, tokenStore))
    );
  });

  beforeEach(async () => {
    savedRestaurants = await setupDb(client);
  });

  afterEach(async () => {
    await cleanupDb(client);
  });

  after(() => {
    client.disconnect();
  });

  it('returns 200 and list of restaurants', async () => {
    await request(app)
      .get('/restaurants?page=1&limit=2')
      .set('Authorization', 'token')
      .expect(200)
      .then((res) => {
        expect(res.body.metadata).to.not.be.empty;
        expect(res.body.restaurants).to.not.be.empty;
      });
  });

  it('returns 200 and restaurant', async () => {
    const id = savedRestaurants[0].id;
    await request(app)
      .get(`/restaurants/restaurant/${id}`)
      .set('Authorization', 'token')
      .expect(200)
      .then((res) => {
        expect(res.body).to.not.be.empty;
        expect(res.body.name).eq('Restuarant Name');
      });
  });

  it('returns 200 and list of restaurants by location', async () => {
    await request(app)
      .get('/restaurants/location?page=1&limit=2&longitude=40.33&latitude=73.23')
      .set('Authorization', 'token')
      .expect(200)
      .then((res) => {
        expect(res.body.metadata).to.not.be.empty;
        expect(res.body.restaurants).to.not.be.empty;
      });
  });

  it('returns 200 and list of restaurants by query', async () => {
    await request(app)
      .get('/restaurants/search?page=1&limit=2&query=name')
      .set('Authorization', 'token')
      .expect(200)
      .then((res) => {
        expect(res.body.metadata).to.not.be.empty;
        expect(res.body.restaurants).to.not.be.empty;
      });
  });

  it('returns 200 and restaurant menu', async () => {
    const id = savedRestaurants[0].id;
    await request(app)
      .get(`/restaurants/restaurant/menu/${id}`)
      .set('Authorization', 'token')
      .expect(200)
      .then((res) => {
        expect(res.body).to.not.be.empty;
        expect(res.body.menu).to.not.be.empty;
      });
  });
});

export default class FakeTokenService implements ITokenService {
  encode(payload: string | object): string | object {
    return payload;
  }
  decode(token: string | object): string | object {
    return token;
  }
}

class FakeTokenStore implements IRedisService {
  save(token: string): void {
    console.log(token);
  }
  async get(_: string): Promise<string> {
    return '';
  }
}
