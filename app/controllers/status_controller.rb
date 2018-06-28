class StatusController < ApplicationController
  def index
    @machines = Machine.by_date
  end

  def imaged_sheet
    send_data Machine.where.not(imaged: nil).where.not(location: nil).to_xlsx,
              filename: "Machines-Imaged-#{Time.zone.today}.xlsx"
  end
end
