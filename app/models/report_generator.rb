# frozen_string_literal: true

class ReportGenerator
  # TODO: - fetch range of events and generate Report

  attr_accessor :params, :employee_id, :from, :to
  def initialize(params)
    @params = params
    @employee_id = params[:employee_id]
    @from = params[:from].present? ? Date.parse(params[:from]) : 400
    @to = params[:to].present? ? Date.parse(params[:to]) : 400
  end

  def generate_report
    events = fetch_events
    
    report = Report.new(employee_id, from, to)
    # events.each { |event| report.add_event(event) }

    report.generate
  end

  private

  def fetch_events
     event = Event.where(employee_id: employee_id, timestamp: from.beginning_of_day..to.end_of_day).order(:timestamp)
     return 400 if event.blank?
      event
  end
end
