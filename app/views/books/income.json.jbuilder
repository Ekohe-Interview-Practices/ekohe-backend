json.income @book.income(@start_date.to_date, @end_date.to_date)
json.book_id @book.id
json.book_title @book.title
json.start_date @start_date
json.end_date @end_date
