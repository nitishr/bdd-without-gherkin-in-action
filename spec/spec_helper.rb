# frozen_string_literal: true

require 'transferring_between_accounts_steps'
require 'show_next_departing_trains_steps'
require 'earning_points_from_flights_steps'

RSpec.configure do |c|
  c.include TransferringBetweenAccountsSteps
  c.include ShowNextDepartingTrainsSteps
  c.include EarningPointsFromFlightsSteps
end
