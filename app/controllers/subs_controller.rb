class SubsController < ApplicationController
  before_action :logged_in?, only: [:new, :create]
  before_action :current_user_is_moderator?, only: [:edit, :update]
  
  def index
    render :index
  end

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.moderator_id = current_user.id
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit
    @sub = Sub.find(params[:id])
    render :edit
  end

  def update
    @sub = Sub.find(params[:id])
    if @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:error] = @sub.errors.full_messages
      render :edit
    end
  end

  def show
    @sub = Sub.where(id: params[:id])[0]
    if @sub
      render :show
    else
      redirect_to subs_url
    end
  end

  def sub_params
    params.require(:sub).permit(:title, :description)
  end
end
