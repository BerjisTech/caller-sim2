# frozen_string_literal: true

class Profile < ApplicationRecord
  has_many :room_members
  has_many :rooms, through: :room_members
end
