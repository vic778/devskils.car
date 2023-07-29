# frozen_string_literal: true

class Event < ApplicationRecord
  # TODO: implement validations and kind of events
  validates :employee_id, presence: true
  validates :timestamp, presence: true
  enum kind: { in: 0, out: 1}
end
