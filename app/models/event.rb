# frozen_string_literal: true

class Event < ApplicationRecord
  # TODO: implement validations and kind of events
  validates :employee_id, presence: true
  validates :timestamp, presence: true
  enum_for :kind, %i[in out]
end
