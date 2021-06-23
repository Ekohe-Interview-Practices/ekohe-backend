class Account < ApplicationRecord
    has_many :loans

    def active_loans
        self.loans.where('active = true')
    end
end
