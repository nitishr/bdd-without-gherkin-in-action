# frozen_string_literal: true
module Banking
  class Client
    attr_reader :name

    def initialize(name)
      @name = name
      @accounts = {}
    end

    def opens(bank_account)
      @accounts[bank_account.account_type] = bank_account
    end

    def account(account_type)
      @accounts[account_type]
    end
  end
end
