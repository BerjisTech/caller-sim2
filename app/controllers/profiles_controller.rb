# frozen_string_literal: true

class ProfilesController < ApplicationController
  respond_to :json

  def index
    @profiles = Profile.all
    render json: @profiles
  end

  # GET /profiles/:id
  def show
    @profile = Profile.find_or_create_by(user_id: params[:id])
    if @profile.nil?
      render json: { error: "Profile not found" }, status: :not_found
    else
      render json: @profile, status: :ok
    end
  end

  # POST /profiles
  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      render json: @profile, status: :created
    else
      render json: { error: @profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /profiles/:id
  def update
    @profile = Profile.find(params[:id])
    if @profile.update(profile_params)
      render json: @profile
    else
      render json: { error: @profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /profiles/:id
  def destroy
    @profile = Profile.find(params[:id])
    if @profile.destroy
      render json: { message: "Profile deleted successfully" }
    else
      render json: { error: "Unable to delete profile" }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(
      :user_id,
      :is_anonymous,
      :is_authenticated,
      :is_superuser,
      :is_staff,
      :username,
      :email,
      :first_name,
      :last_name,
      :full_name,
      :avatar
    )
  end
end
