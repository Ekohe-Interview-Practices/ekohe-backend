json.remaining @book.available
json.loans_count @book.active_loans.length
json.loans @book.active_loans, partial: 'books/book_loans', as: :book_loan
