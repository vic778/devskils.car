# frozen_string_literal: true

class EventsController < ApplicationController
  # TODO: implement the event saving endpoint
  before_action :check_params, only: :save
  before_action :check_params_kind, only: :save
  
  def save
    event = Event.new(event_params)
    event.timestamp = format_time_stamp(event_params[:timestamp])
    
    if event.save
      render json: { message: 'Event saved successfully' }, status: :ok
    else
      render json: { error: 'Failed to save event' }, status: :unprocessable_entity
    end
  end

  private

  def format_time_stamp(timestamp)
    return unless timestamp.present? && timestamp.match?(/\A\d{10}\z/)
    DateTime.strptime(timestamp, '%s')
  end

  def event_params
    params.permit(:employee_id, :timestamp, :kind)
  end

  def check_params_kind
    return errors_params unless params[:kind].present? && params[:kind].include?('in') || params[:kind].include?('out')
  end

  def check_params
    return errors_params unless params[:employee_id].present? && params[:timestamp].present? && params[:kind].present?
  end

  def errors_params
    render json: { error: 'Failed to save event'}, status: :unprocessable_entity
  end
end
