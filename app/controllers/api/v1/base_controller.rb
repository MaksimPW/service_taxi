class Api::V1::BaseController < ApplicationController
  # TODO: Включить, если понадобиться защита с помощью doorkeeper ->
  # before_action :doorkeeper_authorize!

  respond_to :json
end