/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  HttpCode,
  HttpStatus,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { BooksService } from './books.service';
import { CreateBookDto } from './dtos/create_book.dto';
import { UpdateBookDto } from './dtos/update_book.dto';
import { FilterBookDto } from './dtos/filter_book.dto';
import { ApiResponse } from 'src/shared/interfaces/api_responses.interfaces';
import { ApiResponseService } from 'src/shared/api_response.service';

@Controller('books')
export class BooksController {
  constructor(
    private readonly booksService: BooksService,
    private readonly responseService: ApiResponseService,
  ) {}

  @Post('create_book')
  @HttpCode(HttpStatus.CREATED)
  async create(@Body() createBookDto: CreateBookDto) {
    try {
      const book = await this.booksService.create(createBookDto);
      return this.responseService.created(book, 'Book created successfully');
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  @Get('all_books')
  async findAll(@Query() filterDto: FilterBookDto): Promise<ApiResponse<any>> {
    try {
      const { books, total } = await this.booksService.findAll(filterDto);

      return this.responseService.paginate(
        books,
        {
          page: filterDto.page,
          limit: filterDto.limit,
          total,
          totalPages: Math.ceil(total / filterDto.limit),
        },
        'Books retrieved successfully',
      );
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    try {
      const book = await this.booksService.findOne(+id);
      return this.responseService.ok(book, 'Book retrieved successfully');
    } catch (error) {
      if (error instanceof NotFoundException) {
        throw error;
      }
      throw new BadRequestException(error.message);
    }
  }

  @Get('isbn/:isbn')
  async findByIsbn(@Param('isbn') isbn: string) {
    try {
      const book = await this.booksService.findByIsbn(isbn);
      return this.responseService.ok(book, 'Book retrieved successfully');
    } catch (error) {
      if (error instanceof NotFoundException) {
        throw error;
      }
      throw new BadRequestException(error.message);
    }
  }

  @Get('user/:userId')
  async findByUser(@Param('userId') userId: string) {
    try {
      const books = await this.booksService.findByUser(+userId);
      return this.responseService.ok(books, 'Books retrieved successfully');
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  @Put('update/:id')
  async update(@Param('id') id: string, @Body() updateBookDto: UpdateBookDto) {
    try {
      const book = await this.booksService.update(+id, updateBookDto);
      return this.responseService.ok(book, 'Book updated successfully');
    } catch (error) {
      if (error instanceof NotFoundException) {
        throw error;
      }
      throw new BadRequestException(error.message);
    }
  }

  @Delete('/delete/:id')
  async remove(@Param('id') id: string) {
    try {
      await this.booksService.remove(+id);
      return this.responseService.ok(null, 'Book deleted successfully');
    } catch (error) {
      if (error instanceof NotFoundException) {
        throw error;
      }
      throw new BadRequestException(error.message);
    }
  }

  @Get('stats/by-year')
  async getBookCountByYear() {
    try {
      const stats = await this.booksService.getBookCountByYear();
      return this.responseService.ok(
        stats,
        'Book statistics retrieved successfully',
      );
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }
}
