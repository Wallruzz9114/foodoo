import * as mongoose from 'mongoose';

export interface MenuDocument extends mongoose.Document {
  name: string;
  restaurantId: string;
  displayImgUrl: string;
  description: string;
}

export interface MenuItemDocument extends mongoose.Document {
  name: string;
  menuId: string;
  description: string;
  imgUrls: string[];
  unitPrice: number;
}

export interface MenuModel extends mongoose.Model<MenuDocument> {}

export interface MenuItemModel extends mongoose.Model<MenuItemDocument> {}

const MenuItemSchema = new mongoose.Schema({
  name: { type: String, required: true },
  menuId: { type: String, required: true },
  description: { type: String, required: true },
  imgUrls: { type: [String] },
  unitPrice: { type: Number, required: true },
});

const MenuSchema = new mongoose.Schema({
  name: { type: String, required: true },
  restaurantId: { type: String, required: true },
  description: { type: String, required: true },
  displayImgUrl: { type: String },
});

export { MenuSchema, MenuItemSchema };
