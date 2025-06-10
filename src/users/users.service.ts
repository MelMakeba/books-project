/* eslint-disable @typescript-eslint/no-unsafe-return */

import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { ConnectionService } from 'src/database/connection.service';
import { CreateUserDto } from './dtos/create_user.dto';
import { UpdateUserDto } from './dtos/update_user.dto';

@Injectable()
export class UsersService {
  private readonly logger = new Logger(UsersService.name);

  constructor(private readonly connectionService: ConnectionService) {}

  async create(createUserDto: CreateUserDto) {
    try {
      const { username, email, password, first_name, last_name } =
        createUserDto;
      const password_hash = password;

      const result = await this.connectionService.callProcedure('create_user', [
        username,
        email,
        password_hash,
        first_name || null,
        last_name || null,
      ]);

      return result.rows[0];
    } catch (error: unknown) {
      if (error instanceof Error) {
        this.logger.error(`Error creating user: ${error.message}`);
      } else {
        this.logger.error(`Error creating user: ${String(error)}`);
      }
      throw error;
    }
  }

  async findAll() {
    try {
      const result =
        await this.connectionService.callProcedure('get_all_users');
      return result.rows;
    } catch (error: unknown) {
      if (error instanceof Error) {
        this.logger.error(`Error finding users: ${error.message}`);
      } else {
        this.logger.error(`Error finding users: ${String(error)}`);
      }
      throw error;
    }
  }
  async findOne(id: number) {
    const result = await this.connectionService.callProcedure(
      'get_user_by_id',
      [id],
    );

    if (!result.rows.length) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    return result.rows[0];
  }

  async findByUsername(username: string) {
    const result = await this.connectionService.callProcedure(
      'get_user_by_username',
      [username],
    );

    if (!result.rows.length) {
      throw new NotFoundException(`User with username ${username} not found`);
    }

    return result.rows[0];
  }

  async update(id: number, updateUserDto: UpdateUserDto) {
    await this.findOne(id);

    const { email, password, first_name, last_name, is_active } = updateUserDto;

    const password_hash = password || null;

    const result = await this.connectionService.callProcedure('update_user', [
      id,
      email || null,
      password_hash,
      first_name || null,
      last_name || null,
      is_active === undefined ? null : is_active,
    ]);

    return result.rows[0];
  }

  async remove(id: number) {
    await this.findOne(id);

    await this.connectionService.callProcedure('delete_user', [id]);
    return true;
  }
}
