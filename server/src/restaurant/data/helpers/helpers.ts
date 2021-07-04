import { Mongoose } from 'mongoose';
import {
  MenuDocument,
  MenuItemDocument,
  MenuItemModel,
  MenuItemSchema,
  MenuModel,
  MenuSchema,
} from '../models/menuModel';
import RestaurantSchema, { IRestaurantDoc, RestaurantSchemaModel } from '../models/restaurantModel';

const restaurants = [
  {
    name: 'Restuarant Name',
    type: 'Fast Food',
    rating: 4.5,
    displayImgUrl: 'restaurant.jpg',
    location: {
      coordinates: { longitude: 40.33, latitude: 73.23 },
    },
    address: {
      street: 'Road 1',
      city: 'City',
      country: 'Parish',
      province: 'Zone',
    },
  },
  {
    name: 'Restuarant Name',
    type: 'Fast Food',
    rating: 4.5,
    displayImgUrl: 'restaurant.jpg',
    location: {
      coordinates: { longitude: 40.33, latitude: 73.23 },
    },
    address: {
      street: 'Road 1',
      city: 'City',
      country: 'Parish',
      province: 'Zone',
    },
  },
  {
    name: 'Restuarant Name',
    type: 'Fast Food',
    rating: 4.5,
    displayImgUrl: 'restaurant.jpg',
    location: {
      coordinates: { longitude: 40.33, latitude: 73.23 },
    },
    address: {
      street: 'Road 1',
      city: 'City',
      country: 'Parish',
      province: 'Zone',
    },
  },
  {
    name: 'Restuarant Name',
    type: 'Fast Food',
    rating: 4.5,
    displayImgUrl: 'restaurant.jpg',
    location: {
      coordinates: { longitude: 40.33, latitude: 73.23 },
    },
    address: {
      street: 'Road 1',
      city: 'City',
      country: 'Parish',
      province: 'Zone',
    },
  },
  {
    name: 'Restuarant Name',
    type: 'Fast Food',
    rating: 4.5,
    displayImgUrl: 'restaurant.jpg',
    location: {
      coordinates: { longitude: 40.33, latitude: 73.23 },
    },
    address: {
      street: 'Road 1',
      city: 'City',
      country: 'Parish',
      province: 'Zone',
    },
  },
];

const menus = [
  {
    name: 'Lunch',
    description: 'a fun menu',
    image_url: 'menu.jpg',
  },
];

const menuItems = [
  {
    name: 'nuff food',
    description: 'awasome!!',
    image_urls: ['url1', 'url2'],
    unitPrice: 12.99,
  },
  {
    name: 'nuff food',
    description: 'awasome!!',
    image_urls: ['url1', 'url2'],
    unitPrice: 12.99,
  },
];

export const setupDb = async (client: Mongoose) => {
  const restaurantModel = client.model<IRestaurantDoc>(
    'Restaurant',
    RestaurantSchema
  ) as RestaurantSchemaModel;

  const menuModel = client.model<MenuDocument>('Menu', MenuSchema) as MenuModel;
  const menuItemModel = client.model<MenuItemDocument>('MenuItem', MenuItemSchema) as MenuItemModel;

  await restaurantModel.ensureIndexes();

  const restaurantDocs = await restaurantModel.insertMany(restaurants);
  const menuDocs = await insertMenus(restaurantDocs, menuModel);

  await insertMenuItems(menuDocs, menuItemModel);

  return restaurantDocs;
};

export const cleanupDb = async (client: Mongoose) => {
  await client.connection.db.dropCollection('restaurants');
  await client.connection.db.dropCollection('menus');
  await client.connection.db.dropCollection('menuitems');
};

async function insertMenuItems(menuDocs: MenuDocument[], menuItemModel: MenuItemModel) {
  const items: Array<{}> = [];
  menuDocs.forEach(async (menu) => {
    const itemsWithMenuId = menuItems.map((item) => {
      return { menuId: menu.id, ...item };
    });
    items.push(...itemsWithMenuId);
  });

  await menuItemModel.insertMany(items);
}

async function insertMenus(restaurantDocs: IRestaurantDoc[], menuModel: MenuModel) {
  const restaurantMenus: Array<{}> = [];
  restaurantDocs.forEach((res) => {
    const menu = menus.map((menu) => {
      return { restaurantId: res.id, ...menu };
    });
    restaurantMenus.push(...menu);
  });

  const menuDocs = await menuModel.insertMany(restaurantMenus);
  return menuDocs;
}