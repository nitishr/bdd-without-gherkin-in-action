# frozen_string_literal: true

require 'banking'

module TransferringBetweenAccountsSteps
  extend Turnip::DSL
  include Banking

  step ':client_name has a :account_type account with :amount' do |client_name, account_type, amount|
    @client = Client.new(client_name)
    @client.opens(BankAccount.of_type(account_type).with_balance(amount))
  end

  step 'a :account_type account with :amount' do |account_type, amount|
    @client.opens(BankAccount.of_type(account_type).with_balance(amount))
  end

  step 'she transfers :amount from the :source account to the :destination account' do |amount, source, destination|
    Transfer.new.the_amount(amount).from(@client.account(source)).to(@client.account(destination))
  rescue Transfer::InsufficientFundsError => e
    @error = e
  end

  step 'she should have :amount in her :account_type account' do |amount, account_type|
    expect(@client.account(account_type).balance).to eq amount
  end

  step "she should receive an 'insufficient funds' error" do
    expect(@error).to be_a Transfer::InsufficientFundsError
  end

  placeholder(:amount) { match(/\$.*/) { |amount| amount[1..].to_d } }
end
