class GoalsController < ApplicationController
  before_action :ensure_signed_in!

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user = current_user

    if @goal.save
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def show
    @goal = Goal.find(params[:id])

    if @goal.user == current_user || @goal.private_goal == false
      render :show
    else
      redirect_to goals_url
    end
  end

  def edit
    @goal = Goal.find(params[:id])
    if @goal.user == current_user
      render :edit
    else
      redirect_to goals_url
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    user = @goal.user
    if @goal.user == current_user
      @goal.destroy
      redirect_to user_url(user)
    else
      redirect_to goals_url
    end
  end


  def update
    @goal = Goal.find(params[:id])
    # debugger if goal_params[:title] == "New goal title"

    if current_user != @goal.user
      redirect_to goals_url
    elsif @goal.update(goal_params)
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :edit
    end
  end

  def index

    @goals = Goal.where(private_goal: false)
  end

  private

  def goal_params
    params.require(:goal).permit(:title, :description, :status, :private_goal)
  end
end
