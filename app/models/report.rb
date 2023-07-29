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
    @problematic_dates = []

    events_by_day = data.group_by { |event| event.timestamp.to_date }

    events_by_day.each do |date, events|
      has_in = events.any? { |event| event.kind == 'in' }
      has_out = events.any? { |event| event.kind == 'out' }

      if has_in && has_out
        in_event = events.find { |event| event.kind == 'in' }
        out_event = events.find { |event| event.kind == 'out' }

        total_hours += (out_event.timestamp - in_event.timestamp) / 3600
      else
        @problematic_dates << date
      end
    end

    @worktime_hrs = total_hours.round(2)
  end


  def query
    Event.where(employee_id: @employee_id, timestamp: @from.beginning_of_day..@to.end_of_day).order(:timestamp)
  end
end
