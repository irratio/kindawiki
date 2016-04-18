class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :destroy]

  def index
    @page = Page.find_root

    if @page.present?
      render 'show'
    else
      @page = Page.new(
        slug: '',
        title: 'Root page',
        text: "Welcome to kindawiki!\nIt looks like you db is empty."
      )
      render 'new'
    end

  end

  def show
  end

  def new
    parent = Page.find_by_path(params[:path])

    if parent.present?
      @page = Page.new(parent: parent)
    else
      if Page.exists?
        redirect_to new_page_path('')
      else
        redirect_to root_path
      end
    end
  end

  def edit
  end

  def create
    @page = Page.new(page_params)

    if @page.save
      redirect_to @page, notice: 'Page was successfully created.'
    else
      render :new
    end
  end

  def update
    @page = Page.find_by_path(params[:path])

    if @page.present?
      if @page.update(page_params)
        redirect_to @page, notice: 'Page was successfully updated.'
      else
        render :edit
      end
    else
      flash[:notice] = 'Requested page doesn’t exist! But you can create one'
      @page = Page.new(page_params)
      render :new
    end
  end

  def destroy
    target = if @page.parent.present?
      page_path @page.parent
    else
      root_path
    end

    if @page.destroy
      redirect_to target, notice: 'Page was successfully destroyed.'
    else
      redirect_to edit_page_path(@page), notice: @page.errors.messages[:base].join(', ')
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = Page.find_by_path(params[:path])

    raise ActionController::RoutingError.new('Not Found') unless @page.present?
  end

  # Only allow a trusted parameter "white list" through.
  def page_params
    params.require(:page).permit(:title, :text, :slug, :parent_id)
  end
end
