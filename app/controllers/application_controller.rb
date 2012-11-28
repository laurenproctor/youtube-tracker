class ApplicationController < ActionController::Base
  protect_from_forgery
  # inherit_resources

  include ApplicationHelper

  lock :actions=>["home"]

    
end

