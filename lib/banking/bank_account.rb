# frozen_string_literal: true
module Banking
  class BankAccount
    attr_reader :account_type, :balance

    def self.of_type(account_type)
      new(account_type)
    end

    def initialize(account_type)
      @account_type = account_type
    end

    def with_balance(balance)
      @balance = balance
      self
    end

    def deposit(amount)
      @balance += amount
    end

    def withdraw(amount)
      @balance -= amount
    end
  end
end
