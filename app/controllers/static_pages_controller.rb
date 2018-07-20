class StaticPagesController < ApplicationController
  skip_before_action :is_admin?
  
  def home; end
end
