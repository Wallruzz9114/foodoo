import { NextFunction, Request, Response } from 'express';
import { body, validationResult } from 'express-validator';

export const signUpValidationRules = () => {
  return [
    body('username', 'Username is required').notEmpty(),
    body('email', 'Invalid email').notEmpty().isEmail().normalizeEmail(),
    body('password', 'Password is required (min 6 characters)').notEmpty().isLength({ min: 6 }),
  ];
};

export const validate = (req: Request, res: Response, next: NextFunction) => {
  const errors = validationResult(req);
  if (errors.isEmpty()) return next();

  const extractedErrors: any = [];
  errors
    .array({ onlyFirstError: true })
    .map((err) => extractedErrors.push({ [err.param]: err.msg }));

  return res.status(422).json({ errors: extractedErrors });
};
