export class Book {
  id: number;
  title: string;
  author: string;
  publication_year: number;
  isbn: string;
  description?: string;
  user_id?: number;
  created_at: Date;
  updated_at: Date;
}
