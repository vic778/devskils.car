class Report
  include ActiveModel::Validations

  attr_accessor :employee_id, :from, :to, :worktime_hrs, :problematic_dates

  validates :employee_id, presence: true
  validates :from, presence: true
  validates :to, presence: true
  validates :worktime_hrs, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def initialize(employee_id, from, to)
    @employee_id = employee_id
    @from = from
    @to = to
    @worktime_hrs = nil
    @problematic_dates = []
  end

  def generate
    calculate_worktime_hrs
    self
    {employee_id: @employee_id.to_i, from: @from, to: @to, worktime_hrs: @worktime_hrs, problematic_dates: @problematic_dates}
  end

  private

  def calculate_worktime_hrs
    data = query

    total_hours = 0
    
    data.each do |event|
      p event
    end


    @worktime_hrs = total_hours.to_f
  end

  def query
    Event.where(employee_id: @employee_id, timestamp: @from.beginning_of_day..@to.end_of_day).order(:timestamp)
  end
end
