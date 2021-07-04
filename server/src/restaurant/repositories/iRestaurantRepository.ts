import Pageable from '../../models/abstract/pageable';
import { Menu } from '../../models/menu';
import Restaurant from '../../models/restaurant';
import { Location } from './../../models/location';

export default interface IRestaurantRepository {
  getAllRestaurants(currentPage: number, pageSize: number): Promise<Pageable<Restaurant>>;
  getRestaurant(id: string): Promise<Restaurant>;
  getRestaurantsByLocation(
    location: Location,
    page: number,
    pageSize: number
  ): Promise<Pageable<Restaurant>>;
  search(currentPage: number, pageSize: number, query: string): Promise<Pageable<Restaurant>>;
  getMenus(restaurantId: string): Promise<Menu[]>;
}
