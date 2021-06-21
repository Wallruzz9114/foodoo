export default class User {
  public constructor(
    public readonly id: string,
    public readonly username: string,
    public readonly email: string,
    public readonly password: string
  ) {}
}
