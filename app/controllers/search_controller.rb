class SearchController < ApplicationController
    def show
        if params[:search].blank?  
            flash[:alert] = "Search field empty!"
            redirect_back(fallback_location: root_path)
            # binding.pry
        else  
            @search = params[:search]
            @results = Song.joins(:artist).search(params[:search]).order(:name)
        end  
    end

    private

    def search_params
        params.require[:search]
    end
end