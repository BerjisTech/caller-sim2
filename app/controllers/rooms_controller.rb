# frozen_string_literal: true

class RoomsController < ApplicationController
  respond_to? :json

  # /rooms
  def index
    @rooms = Room.all
    render json: @rooms
  end

  def active_rooms
    @rooms = Room.where(is_active: true)
    render json: @rooms
  end

  # /room/:id
  def room
    @room = Room.find(params[:id])
    render json: @room
  end

  # /room_by_tags?tags[]=tag1&tags[]=tag2
  def room_by_tags
    # Find a room that most likely matches tag array string[] provided
    @room = Room.where('tags @> ARRAY[?]::varchar[]', params[:tags])
    render json: @room
  end

  # /room/new
  def create_room
    @room = Room.new(room_params)
    if @room.save
      create_profile_and_member(@room)
      render json: @room
    else
      render json: { error: 'Unable to create room' }, status: 400
    end
  end

  # /room/:id/update
  def update_room
    @room = Room.find(params[:id])
    if @room.update(room_params)
      render json: @room
    else
      render json: { error: 'Unable to update room' }, status: 400
    end
  end

  # /room/:id/members
  def members
    @room = Room.find(params[:id])
    @members = @room.room_members
    render json: @members
  end

  # /room/:id/messages
  def messages
    @room = Room.find(params[:id])
    @messages = @room.room_messages
    render json: @messages
  end

  # /room/:id/messages/:id/reactions
  def message_reactions
    @room = Room.find(params[:id])
    @message = @room.room_messages.find(params[:message_id])
    @reactions = @message.reactions
    render json: @reactions
  end

  # /room/:id/add_member
  def add_member
    @room = Room.find(params[:id])
    create_profile_and_member(@room)
    render json: { message: 'Member added successfully' }
  end

  private

  def room_params
    params.require(:room).permit(:name, :tags)
  end

  def create_profile_and_member(room)
    profile = Profile.find_or_create_by(user_id: current_user.id)
    RoomMember.create(room:, profile:)
  end
end
