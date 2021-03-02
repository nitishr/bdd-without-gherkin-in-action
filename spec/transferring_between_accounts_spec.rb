# frozen_string_literal: true

require 'banking'
module Banking
  RSpec::Matchers.define_negated_matcher :not_change, :change

  RSpec.describe 'Transferring money between accounts' do
    before { @client = Banking::Client.new('Tess') }

    specify 'transferring money to a savings account' do
      current_account.with_balance(1000)
      savings_account.with_balance(2000)
      expect { transfer(500, from: current_account, to: savings_account) }.to(
        change(current_account, :balance).by(-500) & change(savings_account, :balance).by(500))
    end

    specify 'transferring with insufficient funds' do
      current_account.with_balance(1000)
      savings_account.with_balance(2000)
      expect { transfer(1500, from: current_account, to: savings_account) }.to(
        raise_error(Banking::Transfer::InsufficientFundsError) &
              not_change(current_account, :balance) & not_change(savings_account, :balance))
    end

    def current_account
      account(:current)
    end

    def savings_account
      account(:savings)
    end

    def account(account_type)
      @client.account(account_type) || @client.opens(Banking::BankAccount.of_type(account_type))
    end

    def transfer(amount, from:, to:)
      Banking::Transfer.new.the_amount(amount).from(from).to(to)
    end
  end
end
