class RoomMember < ApplicationRecord
  belongs_to :room
  belongs_to :profile
end
