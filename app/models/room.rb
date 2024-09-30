# frozen_string_literal: true

class Room < ApplicationRecord
  belongs_to :profile
  has_many :room_members
  has_many :profiles, through: :room_members

  validates :name, presence: true
end
