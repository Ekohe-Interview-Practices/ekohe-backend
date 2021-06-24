require "test_helper"

class BookTest < ActiveSupport::TestCase
  setup do
  end

  test "Basic maths" do
    assert(books(:one).available, 1)
    assert(books(:one).active_loans.length, 2)
    books(:one).returns(accounts(:two))
    assert(books(:one).available, 2)
    assert(books(:one).loans.length, 2)
    assert(books(:one).active_loans.length, 1)
    books(:three).borrow(accounts(:two))
    books(:three).borrow(accounts(:two))
    books(:three).borrow(accounts(:two))
  end

  test "Can't borrow more than available" do
    assert(books(:ddd).available, 0)
    assert_raises(Exceptions::NoBookCopies) { 
      books(:ddd).borrow(accounts(:two))
    }
  end
end
