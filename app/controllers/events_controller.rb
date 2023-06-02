# frozen_string_literal: true

class EventsController < ApplicationController
  # TODO: implement the event saving endpoint
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
end
