# frozen_string_literal: true

class ReportsController < ApplicationController
  # TODO: implement report generation endpoint - it should delegate to ReportGenerator

  def get

    if !validate_date_format(params[:from]) || !validate_date_format(params[:to]) || !validate_employee_id(params[:employee_id])
      render json: { error: 'Failed to generate report' }, status: :bad_request
      return  false
    end

    report_generator = ReportGenerator.new(params)
    report = report_generator.generate_report
    # report_data = report
    # binding.pry

    if report
      render json: report.to_json, status: :ok
    else
      render json: { error: 'Failed to generate report' }, status: :unprocessable_entity
    end
  end

  private

  def validate_report_params
    params.permit(:employee_id, :from, :to)
  end

  def validate_date_format(date)
    date.match?(/\A\d{4}-\d{2}-\d{2}\z/) || date.match?(/\A\d{2}-\d{2}-\d{4}\z/)
  end

  def validate_employee_id(employee_id)
    employee_id.to_i > 0
  end
end
