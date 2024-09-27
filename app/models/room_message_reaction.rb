# frozen_string_literal: true

class RoomMessageReaction < ApplicationRecord
  belongs_to :room_message
  belongs_to :profile
end
