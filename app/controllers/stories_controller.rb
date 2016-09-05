class StoriesController < ApplicationController
  before_action :find_story, only: [:destroy, :show, :edit, :update, :like]
  before_action :load_activities, only: [:index, :show, :new, :edit]
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @stories = Story.order('created_at DESC')
    @story = Story.new
  end

  def new
  end

  def create
    @story = Story.new(story_params)
    @story.user = current_user
    if @story.save
      flash[:success] = 'Your story was added!'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @story.update_attributes(story_params)
      flash[:success] = 'The story was edited!'
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    without_tracking do
      if @story.destroy
        flash[:success] = 'The story was deleted!'
      else
        flash[:error] = 'Cannot delete this story...'
      end
    end
    redirect_to root_path
  end

  def show
  end

  def like
    without_tracking do
      @likes = Like.new(user_id: current_user.id, story_id: @story.id)
    end
    if @likes.save
      flash[:success] = 'Thanks for the like!'
    else
      flash[:error] = 'Please try again.'
    end
    redirect_to :back
  end

  private

  def story_params
    params.require(:story).permit(:title, :body)
  end

  def like_params
    params.require(:likes).permit(:user_id, :story_id)
  end

  def find_story
    @story = Story.find(params[:id])
  end

  def load_activities
    @activities = PublicActivity::Activity.order('created_at DESC').limit(20)
  end

  def without_tracking
    Story.public_activity_off
    yield if block_given?
    Story.public_activity_on
  end
end
