class Book < ApplicationRecord
    has_many :loans

    ##
    # Returns how many copies available from active loans
    def available
        self.count - self.active_loans.length
    end

    def active_loans
        self.loans.where('active = true')
    end
end
