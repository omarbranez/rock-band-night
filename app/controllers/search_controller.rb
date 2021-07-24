class SearchController < ApplicationController
    def show
        if params[:search].blank?  
            redirect_to(search_page_path, alert: "Empty field!") and return
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