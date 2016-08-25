class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @users = User.all.where.not(id: current_user.id)
  end

  def show
    @user = User.find(params[:id])
  end

  def dashboard
    @user = current_user
    @books = @user.books
  end

  def destroy
    @user = current_user

    respond_to do |format|
      if @user.destroy()
        format.html { redirect_to root_path, alert: 'Your account has been deleted!' }
        format.json { head :no_content }
      else
        format.html { redirect_to root_path, alert: 'Failed to delete account. Please try again.' }
      end
    end
  end

  def create_invitation
    userExists = User.where(email: params[:email])
    invitationAccepted = user.pluck(:invitation_accepted_at)

    if userExists.empty?
      User.invite!({:email => params[:email]}, current_user)
      redirect_to user_dashboard_path, notice: "Invitation successfully sent."
    elsif !userExists.empty? and ! invitationAccepted.any?
      User.invite!({:email => params[:email]}, current_user)
      redirect_to user_dashboard_path, alert: "User has already been invited. Seding a fresh invite."
    else
      redirect_to user_dashboard_path, alert: "User already exists. No invitation sent."
    end
  end

end
