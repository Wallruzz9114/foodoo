import mongoose, { PaginateResult } from 'mongoose';
import { default as Pageable, default as pageable } from '../../../models/abstract/pageable';
import { Location } from '../../../models/location';
import { Menu } from '../../../models/menu';
import { MenuItem } from '../../../models/menuItem';
import Restaurant from '../../../models/restaurant';
import IRestaurantRepository from '../../../restaurant/repositories/iRestaurantRepository';
import { MenuDocument, MenuSchema } from '../models/menuModel';
import restaurantSchema, { IRestaurantDoc, RestaurantSchemaModel } from '../models/restaurantModel';
import { MenuItemDocument, MenuItemModel, MenuItemSchema, MenuModel } from './../models/menuModel';

export class RestaurantRepository implements IRestaurantRepository {
  constructor(private readonly client: mongoose.Mongoose) {}

  public async getAllRestaurants(
    currentPage: number,
    pageSize: number
  ): Promise<pageable<Restaurant>> {
    const restaurantModel = this.client.model<IRestaurantDoc>(
      'Restaurant',
      restaurantSchema
    ) as RestaurantSchemaModel;

    const pageOptions = { page: currentPage, limit: pageSize };
    const pageResults = await restaurantModel.paginate({}, pageOptions).catch((_) => null);

    return this.restaurantsFromPageResults(pageResults);
  }

  public async getRestaurant(id: string): Promise<Restaurant> {
    const restaurantModel = this.client.model<IRestaurantDoc>(
      'Restaurant',
      restaurantSchema
    ) as RestaurantSchemaModel;

    const result = await restaurantModel.findById(id);

    if (result === null) {
      return Promise.reject('Restaurant not found');
    }

    return new Restaurant(
      result.id,
      result.name,
      result.type,
      result.rating,
      result.displayImgUrl,
      result.location.coordinates,
      result.address
    );
  }

  public async getRestaurantsByLocation(
    location: Location,
    page: number,
    pageSize: number
  ): Promise<pageable<Restaurant>> {
    const restaurantModel = this.client.model<IRestaurantDoc>(
      'Restaurant',
      restaurantSchema
    ) as RestaurantSchemaModel;

    const pageOptions = { page: page, limit: pageSize, forceCountFn: true };

    const geoQuery = {
      location: {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: [location.longitude, location.latitude],
          },
          $maxDistance: 2,
        },
      },
    };

    const pageResults = await restaurantModel.paginate(geoQuery, pageOptions).catch((_) => null);

    return this.restaurantsFromPageResults(pageResults);
  }

  public async search(
    currentPage: number,
    pageSize: number,
    query: string
  ): Promise<pageable<Restaurant>> {
    const restaurantModel = this.client.model<IRestaurantDoc>(
      'Restaurant',
      restaurantSchema
    ) as RestaurantSchemaModel;

    const pageOptions = { page: currentPage, limit: pageSize };
    const textQuery = { $text: { $search: query } };
    const pageResults = await restaurantModel.paginate(textQuery, pageOptions).catch((_) => null);

    return this.restaurantsFromPageResults(pageResults);
  }

  public async getMenus(restaurantId: string): Promise<Menu[]> {
    const menuModel = this.client.model<MenuDocument>('Menu', MenuSchema) as MenuModel;

    const menuItemModel = this.client.model<MenuItemDocument>(
      'MenuItem',
      MenuItemSchema
    ) as MenuItemModel;

    const menus = await menuModel.find({ restaurantId: restaurantId });
    if (menus === null) return Promise.reject('No menus found');
    const menuIds = menus.map((m) => m.id);

    const items = await menuItemModel.find({ menuId: { $in: menuIds } });

    return this.menusWithItems(menus, items);
  }

  private restaurantsFromPageResults(pageResults: PaginateResult<IRestaurantDoc> | null) {
    if (pageResults === null || pageResults.docs.length === 0)
      return Promise.reject('Restaurants not found');

    const results = pageResults.docs.map<Restaurant>(
      (model) =>
        new Restaurant(
          model.id,
          model.name,
          model.type,
          model.rating,
          model.displayImgUrl,
          model.location.coordinates,
          model.address
        )
    );

    return new Pageable<Restaurant>(
      pageResults.page ?? 0,
      pageResults.limit,
      pageResults.totalPages,
      results
    );
  }

  private menusWithItems(menus: MenuDocument[], items: MenuItemDocument[]): Menu[] {
    return menus.map(
      (menu) =>
        new Menu(
          menu.id,
          menu.restaurantId,
          menu.name,
          menu.displayImgUrl,
          menu.description,
          items
            .filter((item) => item.menuId === menu.id)
            .map(
              (menuItem) =>
                new MenuItem(
                  menuItem.id,
                  menuItem.menuId,
                  menuItem.name,
                  menuItem.description,
                  menuItem.imgUrls,
                  menuItem.unitPrice
                )
            )
        )
    );
  }
}
