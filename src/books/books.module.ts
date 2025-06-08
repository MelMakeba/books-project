import { Module } from '@nestjs/common';
import { BooksService } from './books.service';
import { BooksController } from './books.controller';
import { ConnectionService } from 'src/database/connection.service';
import { DatabaseConfig } from 'src/config/database.config';

@Module({
  providers: [BooksService, ConnectionService, DatabaseConfig],
  controllers: [BooksController],
})
export class BooksModule {}
