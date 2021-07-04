import * as mongoose from 'mongoose';
import pagination from 'mongoose-paginate-v2';
import { Address } from '../../../models/address';
import { Location } from './../../../models/location';

export interface IRestaurantDoc extends mongoose.Document {
  name: string;
  type: string;
  rating: number;
  displayImgUrl: string;
  location: { coordinates: Location };
  address: Address;
}

export interface RestaurantSchemaModel extends mongoose.PaginateModel<IRestaurantDoc> {}

const pointSchema = new mongoose.Schema({
  type: {
    type: String,
    default: 'Point',
    enum: ['Point'],
    required: true,
  },
  coordinates: {
    type: {
      longitude: { type: Number },
      latitude: { type: Number },
    },
    required: true,
  },
});

const restaurantSchema = new mongoose.Schema({
  name: { type: String, required: true, index: 'text' },
  type: { type: String, required: true },
  rating: { type: Number, required: true, min: 0, max: 5 },
  displayImgUrl: { type: String, required: true },
  location: {
    type: pointSchema,
    index: '2dsphere',
  },
  address: {
    street: { type: String, required: true },
    city: { type: String, required: true },
    province: { type: String },
    country: { type: String, required: true },
  },
});

restaurantSchema.plugin(pagination);
export default restaurantSchema;
