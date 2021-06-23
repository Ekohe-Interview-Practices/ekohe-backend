json.user_id @account.user_id
json.balance @account.amount
json.borrowed @account.active_loans, partial: 'accounts/book_loans', as: :book_loan