import { Module } from '@nestjs/common';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';
import { ConnectionService } from 'src/database/connection.service';
import { DatabaseConfig } from 'src/config/database.config';

@Module({
  controllers: [UsersController],
  providers: [UsersService, ConnectionService, DatabaseConfig],
})
export class UsersModule {}
