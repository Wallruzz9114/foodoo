import { Address } from './address';
import { Location } from './location';

export default class Restaurant {
  constructor(
    public readonly id: string,
    public readonly name: string,
    public readonly type: string,
    public readonly rating: number,
    public readonly displayImageUrl: string,
    public readonly location: Location,
    public readonly address: Address
  ) {}
}
