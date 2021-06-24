require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "adjust ammount 1" do
    ac1 = accounts(:one)
    initial_amount = ac1.amount
    fees = 0
    while ac1.active_loans.length > 0 do
      loan = ac1.active_loans.first
      fees = fees + loan.book.fee
      loan.book.returns(ac1)
    end
    assert(initial_amount, ac1.amount + fees)
  end
end
