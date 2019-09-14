class TasksController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :new, :create, :edit, :update, :delete]
  before_action :correct_user, only: [:index, :show, :new, :create, :update, :show, :edit, :delete]
  before_action :set_task, only: [:edit, :update, :destroy]

  
  def index
    @tasks = Task.where(user_id: @current_user)
  end

  def show
   @current_user
  end

  def new 
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'Taskが正常に保存された'
      redirect_to @task
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'Taskが保存されなかったよ'
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Taskは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Taskは更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy
    
    flash[:success] = 'Taskは正常に削除されました'
    redirect_to tasks_url
  end

  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  def task_params
    params.require(:task).permit(:status, :content)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
    redirect_to root_url
    end
  end
end
