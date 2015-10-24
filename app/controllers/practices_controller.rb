class PracticesController < ApplicationController
  before_action :require_login
  before_action :set_practice, only: %w(show edit update destroy sort)
  respond_to :html, :json

  def index
    @categories = Category.order('position')
  end

  def show
  end

  def new
    @practice = Practice.new
  end

  def edit
  end

  def create
    @practice = Practice.new(practice_params)

    if @practice.save
      notify "<#{url_for(current_user)}|#{current_user.login_name}>が<#{url_for(@practice)}|#{@practice.title}>を作成しました。"
      redirect_to @practice, notice: t('practice_was_successfully_created')
    else
      render :new
    end
  end

  def update
    old_practice = @practice.dup
    if @practice.update(practice_params)
      text = "<#{url_for(current_user)}|#{current_user.login_name}>が<#{url_for(@practice)}|#{@practice.title}>を編集しました。"
      notify text, pretext: text, title: "差分", value: Diffy::Diff.new(old_practice.all_text + "\n", @practice.all_text + "\n").to_s
      flash[:notice] = t('practice_was_successfully_updated')
    end
    respond_with @practice
  end

  def destroy
    @practice.destroy
    notify "<#{url_for(current_user)}|#{current_user.login_name}>が<#{url_for(@practice)}|#{@practice.title}>を削除しました。"
    redirect_to practices_url, notice: t('practice_was_successfully_deleted')
  end

  private

  def practice_params
    params.require(:practice).permit(
      :title,
      :description,
      :goal,
      :category_id,
      :position
    )
  end

  def set_practice
    @practice = Practice.find(params[:id])
  end
end
