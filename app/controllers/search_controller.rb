# frozen_string_literal: true

class SearchController < ApplicationController
  def search
    @results = model_klass.search(params[:search_query])
    render :result
  end

  private

  def model_klass
    return ThinkingSphinx if params[:search_type] == 'all'
    params[:search_type].camelize.constantize
  end
end
