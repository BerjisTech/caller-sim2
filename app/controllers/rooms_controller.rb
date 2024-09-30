# frozen_string_literal: true

class RoomsController < ApplicationController
  respond_to :json

  # /rooms
  def index
    @rooms = Room.all
    render json: @rooms
  end

  def active_rooms
    @rooms = Room.where(is_active: true)
    render json: @rooms
  end

  def show
    @room = Room.find_by(id: params[:id]) || Room.find_by(name: params[:id])
    if @room.nil?
      render json: { error: 'Room not found' }, status: :not_found
    else
      render json: @room, status: :ok
    end
  end

  # /room_by_tags?tags[]=tag1&tags[]=tag2
  def room_by_tags
    # Ensure tags are passed correctly as an array
    tags_array = params[:tags].is_a?(String) ? params[:tags].split(',') : params[:tags]

    # Find rooms that contain any of the provided tags
    @rooms = Room.where('tags && ARRAY[?]::varchar[]', tags_array)

    render json: @rooms
  end

  # /room/new
  def create
    # Step 1: Create or find the profile for the room host
    profile = create_or_fetch_profile(room_host_params)

    # Step 2: Create the room, assigning the profile (room creator)
    @room = Room.new(room_params.merge(profile_id: profile.id))

    if @room.save
      render json: @room, status: :created
    else
      render json: { error: @room.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # /room/:id/update
  def update
    @room = Room.find(params[:id])
    if @room.update(room_params)
      render json: @room
    else
      render json: { error: 'Unable to update room' }, status: :unprocessable_entity
    end
  end

  # /rooms/:id/members
  def members
    @room = Room.find(params[:id])
    @members = @room.room_members
    render json: @members
  end

  # /rooms/:id/messages
  def messages
    @room = Room.find(params[:id])
    @messages = @room.room_messages
    render json: @messages
  end

  # /rooms/:id/messages/:id/reactions
  def message_reactions
    @room = Room.find(params[:id])
    @message = @room.room_messages.find(params[:message_id])
    @reactions = @message.reactions
    render json: @reactions
  end

  # /rooms/:id/add_member
  def add_member
    @room = Room.find(params[:id])
    create_profile_and_member(@room, params[:profile])
    render json: { message: 'Member added successfully' }
  end

  private

  # Permitted params for room creation
  def room_host_params
    params.require(:room_host).permit(:user_id, :name, :email, :phone_number, :other_profile_fields)
  end

  # Permit the required room fields
  def room_params
    params.require(:room_data).permit(
      :name,
      :description,
      :seats,
      :is_private,
      :password,
      :is_active,
      tags: []
    )
  end

  # Create a profile and add the member to the room
  def create_or_fetch_profile(room_host_data)
    Profile.find_or_create_by(user_id: room_host_data[:user_id]) do |profile|
      profile.assign_attributes(room_host_data)
    end
  end
end
