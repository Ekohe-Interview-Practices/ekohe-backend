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

    def finished_loans
        self.loans.where('active = false')
    end

    def income(start_date, end_date)
        loans = self.finished_loans.where(updated_at: start_date..end_date)
        loans.length * self.fee
    end
    
    def borrow(account)
        ActiveRecord::Base.transaction do
            # Check not available copies for a new loan:
            raise Exceptions::NoBookCopies if self.available == 0
            # Check user haven't enougth balance:
            raise Exceptions::LowAccountBalance if !account.can_afford(self.fee)
            loan = Loan.new
            loan.book = self
            loan.account = account
            loan.save # New loan registered
        end
    end

    def returns(account)
        ActiveRecord::Base.transaction do
            loan = self.active_loans.where(:account => account).first
            raise Exceptions::InvalidLoan unless loan
            account.pay(self.fee)
            loan.finish
        end        
    end
end
