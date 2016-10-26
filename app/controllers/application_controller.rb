class ApplicationController < ActionController::Base
  before_action :set_paper_trail_whodunnit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # TODO: Включить, если понадобиться защита с помощью doorkeeper ->
  # protect_from_forgery with: :exception
end
