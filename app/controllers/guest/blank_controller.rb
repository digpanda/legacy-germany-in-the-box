class Guest::BlankController < ApplicationController
  layout 'blank/default'

  # blank page to show specific messages
  # the user must leave the page afterwards
  # e.g. email confirmation
  def show
  end

end
