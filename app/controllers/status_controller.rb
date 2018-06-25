class StatusController < ApplicationController

  def index
    @machines = Machine.by_date
  end
end
