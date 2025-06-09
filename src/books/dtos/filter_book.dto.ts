export class FilterBookDto {
  searchTerm?: string;
  startYear: number;
  endYear: number;
  page: number = 1;
  limit: number = 10;
}
