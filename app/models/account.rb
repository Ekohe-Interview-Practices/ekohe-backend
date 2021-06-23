class Account < ApplicationRecord
    has_many :loans

    def active_loans
        self.loans.where('active = true')
    end

    def can_afford(fee)
        self.amount - fee >= 0
    end

    def pay(fee)
        self.amount = self.amount - fee
        if self.amount >= 0
            self.save
        else
            raise Exceptions::LowAccountBalance
        end
    end
end
