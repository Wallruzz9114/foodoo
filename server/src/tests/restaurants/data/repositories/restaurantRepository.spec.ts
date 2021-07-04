import { expect } from 'chai';
import dotenv from 'dotenv';
import mongoose from 'mongoose';
import { cleanupDb, setupDb } from '../../../../restaurant/data/helpers/helpers';
import { Location } from './../../../../models/location';
import { RestaurantRepository } from './../../../../restaurant/data/repositories/restaurantRepository';

dotenv.config();

describe('RestaurantRepository', () => {
  let client: mongoose.Mongoose;
  let repository: RestaurantRepository;

  beforeEach(() => {
    client = new mongoose.Mongoose();
    const connectionString = encodeURI(process.env.TEST_DB as string);

    client.connect(connectionString, {
      useNewUrlParser: true,
      useCreateIndex: true,
      useUnifiedTopology: true,
    });

    repository = new RestaurantRepository(client);
  });

  describe('getAllRestaurants', () => {
    beforeEach(async () => {
      await setupDb(client);
    });

    afterEach(async () => {
      await cleanupDb(client);
    });

    it('should return all restaurants', async () => {
      const result = await repository.getAllRestaurants(1, 2);
      expect(result).to.not.be.empty;
      expect(result.data.length).equal(2);
    });
  });

  describe('getRestaurant', () => {
    var insertedId = '';

    beforeEach(async () => {
      const docs = await setupDb(client);
      insertedId = docs[0].id;
    });

    afterEach(async () => {
      await cleanupDb(client);
    });

    it('return a promise reject with error message', async () => {
      await repository.getRestaurant('no_id').catch((err) => {
        expect(err).not.be.empty;
      });
    });

    it('should return a found restaurant', async () => {
      const result = await repository.getRestaurant(insertedId);
      expect(result.id).eq(insertedId);
    });
  });

  describe('getRestaurantsByLocation', () => {
    beforeEach(async () => {
      await setupDb(client);
    });

    afterEach(async () => {
      await cleanupDb(client);
    });

    it('return a promise reject with error message', async () => {
      const location = new Location(20.33, 73.33);
      await repository.getRestaurantsByLocation(location, 1, 2).catch((err) => {
        expect(err).not.be.empty;
      });
    });

    it('should return a found restaurant', async () => {
      const location = new Location(40.33, 73.23);
      const results = await repository.getRestaurantsByLocation(location, 1, 2);

      expect(results.data.length).eq(2);
    });
  });

  describe('search', () => {
    beforeEach(async () => {
      await setupDb(client);
    });

    afterEach(async () => {
      await cleanupDb(client);
    });

    it('returns promise reject with error message when no restaurant is found', async () => {
      const query = 'not present';
      await repository.search(1, 2, query).catch((err) => {
        expect(err).to.not.be.empty;
      });
    });

    it('returns restaurants that matches query string', async () => {
      const query = 'restaurant name';
      const results = await repository.search(1, 2, query);
      expect(results.data.length).to.eq(2);
    });
  });

  describe('getMenus', () => {
    var insertedId = '';
    beforeEach(async () => {
      const docs = await setupDb(client);
      insertedId = docs[0].id;
    });

    afterEach(async () => {
      await cleanupDb(client);
    });

    it('return restaurant menus', async () => {
      const menus = await repository.getMenus(insertedId);
      expect(menus.length).to.eq(1);
      expect(menus[0].items.length).to.eq(2);
    });
  });

  afterEach(() => {
    client.disconnect();
  });
});
