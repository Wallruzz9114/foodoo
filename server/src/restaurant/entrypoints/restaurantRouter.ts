import * as express from 'express';
import TokenValidator from 'src/auth/helpers/tokenValidator';
import IRestaurantRepository from 'src/restaurant/repositories/iRestaurantRepository';
import RestaurantController from './restaurantController';

export default class RestaurantRouter {
  public static configure(
    repository: IRestaurantRepository,
    tokenValidator: TokenValidator
  ): express.Router {
    const router = express.Router();
    let controller = new RestaurantController(repository);

    router.get(
      '/',
      (req, res, next) => tokenValidator.validate(req, res, next),
      (req, res) => controller.getAllRestaurants(req, res)
    );

    router.get(
      '/restaurant/:id',
      (req, res, next) => tokenValidator.validate(req, res, next),
      (req, res) => controller.getRestaurant(req, res)
    );

    router.get(
      '/location',
      (req, res, next) => tokenValidator.validate(req, res, next),
      (req, res) => controller.getRestaurantsByLocation(req, res)
    );

    router.get(
      '/search',
      (req, res, next) => tokenValidator.validate(req, res, next),
      (req, res) => controller.search(req, res)
    );

    router.get(
      '/restaurant/menu/:id',
      (req, res, next) => tokenValidator.validate(req, res, next),
      (req, res) => controller.getMenus(req, res)
    );

    return router;
  }
}
