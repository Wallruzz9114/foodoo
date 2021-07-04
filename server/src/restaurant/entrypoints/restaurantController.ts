import * as express from 'express';
import IRestaurantRepository from 'src/restaurant/repositories/iRestaurantRepository';
import { Location } from './../../models/location';

export default class RestaurantController {
  constructor(private readonly repository: IRestaurantRepository) {}

  public async getAllRestaurants(req: express.Request, res: express.Response) {
    try {
      const { page, limit } = { ...req.query } as { page: any; limit: any };

      return this.repository
        .getAllRestaurants(parseInt(page), parseInt(limit))
        .then((pageable) =>
          res.status(200).json({
            metadata: {
              page: pageable.page,
              pageSize: pageable.pageSize,
              totalPages: pageable.totalPages,
            },
            restaurants: pageable.data,
          })
        )
        .catch((err: Error) => res.status(404).json({ error: err }));
    } catch (error) {
      return res.status(400).json({ error: error });
    }
  }

  public async getRestaurant(req: express.Request, res: express.Response) {
    try {
      const { id } = req.params;
      return this.repository
        .getRestaurant(id)
        .then((restaurant) => res.status(200).json(restaurant))
        .catch((err: Error) => res.status(404).json({ error: err }));
    } catch (error) {
      return res.status(400).json({ error: error });
    }
  }

  public async getRestaurantsByLocation(req: express.Request, res: express.Response) {
    try {
      const { page, limit, longitude, latitude } = req.query as {
        page: string;
        limit: string;
        longitude: string;
        latitude: string;
      };

      const location = new Location(parseFloat(longitude), parseFloat(latitude));
      return this.repository
        .getRestaurantsByLocation(location, parseInt(page), parseInt(limit))
        .then((pageable) =>
          res.status(200).json({
            metadata: {
              page: pageable.page,
              pageSize: pageable.pageSize,
              totalPages: pageable.totalPages,
            },
            restaurants: pageable.data,
          })
        )
        .catch((err: Error) => res.status(404).json({ error: err }));
    } catch (error) {
      return res.status(400).json({ error: error });
    }
  }

  public async search(req: express.Request, res: express.Response) {
    try {
      const { page, limit, query } = req.query as {
        page: any;
        limit: any;
        query: string;
      };
      return this.repository
        .search(parseInt(page), parseInt(limit), query)
        .then((pageable) =>
          res.status(200).json({
            metadata: {
              page: pageable.page,
              pageSize: pageable.pageSize,
              totalPages: pageable.totalPages,
            },
            restaurants: pageable.data,
          })
        )
        .catch((err: Error) => res.status(404).json({ error: err }));
    } catch (err) {
      return res.status(400).json({ error: err });
    }
  }

  public async getMenus(req: express.Request, res: express.Response) {
    try {
      const { id } = req.params;
      return this.repository
        .getMenus(id)
        .then((menus) =>
          res.status(200).json({
            menu: menus,
          })
        )
        .catch((err: Error) => res.status(404).json({ error: err }));
    } catch (error) {
      return res.status(400).json({ error: error });
    }
  }
}
