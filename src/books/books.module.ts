import { Module } from '@nestjs/common';
import { BooksService } from './books.service';
import { BooksController } from './books.controller';
import { ConnectionService } from 'src/database/connection.service';
import { DatabaseConfig } from 'src/config/database.config';
import { ApiResponseService } from 'src/shared/api_response.service';

@Module({
  providers: [
    BooksService,
    ConnectionService,
    DatabaseConfig,
    ApiResponseService,
  ],
  controllers: [BooksController],
  exports: [BooksService],
})
export class BooksModule {}
