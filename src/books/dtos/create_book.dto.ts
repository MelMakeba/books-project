/* eslint-disable @typescript-eslint/no-unsafe-call */
import { IsNotEmpty, IsEmail, IsString, IsOptional } from 'class-validator';

export class CreateUserDto {
  @IsNotEmpty()
  @IsString()
  username: string;

  @IsEmail()
  email: string;

  @IsNotEmpty()
  @IsString()
  password: string;

  @IsOptional()
  @IsString()
  first_name?: string;

  @IsOptional()
  @IsString()
  last_name?: string;
}

export class CreateBookDto {
  title: string;
  author: string;
  publication_year: number;
  isbn: string;
  description?: string;
  user_id?: number;
}
