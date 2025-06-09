/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-return */
import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { ConnectionService } from 'src/database/connection.service';
import { CreateBookDto } from './dtos/create_book.dto';
import { UpdateBookDto } from './dtos/update_book.dto';
import { FilterBookDto } from './dtos/filter_book.dto';

@Injectable()
export class BooksService {
  private readonly logger = new Logger(BooksService.name);

  constructor(private readonly connectionService: ConnectionService) {}

  async create(createBookDto: CreateBookDto): Promise<Record<string, any>> {
    const { title, author, publication_year, isbn, description, user_id } =
      createBookDto;

    const result = await this.connectionService.callProcedure('create_book', [
      title,
      author,
      publication_year,
      isbn,
      description || null,
      user_id || null,
    ]);

    return result.rows[0];
  }

  async findAll(filterDto: FilterBookDto) {
    try {
      const result =
        await this.connectionService.callProcedure('get_all_books');
      let books = result.rows;

      if (filterDto.searchTerm) {
        const searchTermLower = filterDto.searchTerm.toLowerCase();
        books = books.filter(
          (book) =>
            book.title.toLowerCase().includes(searchTermLower) ||
            book.author.toLowerCase().includes(searchTermLower) ||
            book.isbn.toLowerCase().includes(searchTermLower) ||
            (book.description &&
              book.description.toLowerCase().includes(searchTermLower)),
        );
      }

      if (filterDto.startYear && filterDto.endYear) {
        books = books.filter(
          (book) =>
            book.publication_year >= filterDto.startYear &&
            book.publication_year <= filterDto.endYear,
        );
      } else if (filterDto.startYear) {
        books = books.filter(
          (book) => book.publication_year >= filterDto.startYear,
        );
      } else if (filterDto.endYear) {
        books = books.filter(
          (book) => book.publication_year <= filterDto.endYear,
        );
      }

      const total = books.length;

      const page = filterDto.page || 1;
      const limit = filterDto.limit || 10;
      const startIndex = (page - 1) * limit;
      const endIndex = page * limit;

      const paginatedBooks = books.slice(startIndex, endIndex);

      return { books: paginatedBooks, total };
    } catch (error) {
      this.logger.error(`Error finding books: ${error.message}`);
      throw error;
    }
  }

  async findOne(id: number) {
    const result = await this.connectionService.callProcedure(
      'get_book_by_id',
      [id],
    );

    if (!result.rows.length) {
      throw new NotFoundException(`Book with ID ${id} not found`);
    }

    return result.rows[0];
  }

  async findByIsbn(isbn: string) {
    const result = await this.connectionService.callProcedure(
      'get_book_by_isbn',
      [isbn],
    );

    if (!result.rows.length) {
      throw new NotFoundException(`Book with ISBN ${isbn} not found`);
    }

    return result.rows[0];
  }

  async findByUser(userId: number) {
    const result = await this.connectionService.callProcedure(
      'get_books_by_user',
      [userId],
    );
    return result.rows;
  }

  async update(id: number, updateBookDto: UpdateBookDto) {
    await this.findOne(id);

    const { title, author, publication_year, isbn, description, user_id } =
      updateBookDto;

    const result = await this.connectionService.callProcedure('update_book', [
      id,
      title || null,
      author || null,
      publication_year || null,
      isbn || null,
      description || null,
      user_id || null,
    ]);

    return result.rows[0];
  }

  async remove(id: number) {
    await this.findOne(id);

    await this.connectionService.callProcedure('delete_book', [id]);
    return true;
  }

  async getBookCountByYear() {
    const result = await this.connectionService.callProcedure(
      'count_books_by_year',
    );
    return result.rows;
  }
}
