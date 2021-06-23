class Loan < ApplicationRecord
  belongs_to :book
  belongs_to :account
end
