# frozen_string_literal: true
module Banking
  class Transfer
    class InsufficientFundsError < StandardError; end

    def the_amount(amount_to_transfer)
      @amount_to_transfer = amount_to_transfer
      self
    end

    def from(source_account)
      @source_account = source_account
      self
    end

    def to(destination_account)
      raise InsufficientFundsError if @source_account.balance < @amount_to_transfer

      @source_account.withdraw(@amount_to_transfer)
      destination_account.deposit(@amount_to_transfer)
    end
  end
end
