class BookmarksController < ApplicationController
  def new
    @list = List.find(params[:list_id])
    @bookmark = Bookmark.new
  end

  def create
    # need to give it a list
    @list = List.find(params[:list_id])
    # make a new bookmark
    @bookmark = Bookmark.new(bookmark_params)
    # connects the bookmark to the list
    @bookmark.list = @list

    if @bookmark.save
    redirect_to list_path(@list)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @list = List.find(params[:list_id])
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy

    redirect_to list_path(@list), status: :see_other
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:comment, :movie_id)
  end
end
