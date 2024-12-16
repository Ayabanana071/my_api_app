class ArticlesController < ApplicationController
  def create
    article = Article.new(article_params)

    if article.save
      render json: { message: 'Article created successfully', article: article }, status: :created
    else
      render json: { errors: article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :user_id)
  end
end
