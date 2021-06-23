class Loan < ApplicationRecord
  belongs_to :book
  belongs_to :account

  # Demotrative purposes, it really should be done with a migration at data level
  after_initialize :init_fresh, if: :new_record?

  def init_fresh
    self.active = true
  end
end
