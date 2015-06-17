class DrugsController < ApplicationController
  
  def index
    @drugs = [
      {name: 'prozac', id: 1},
      {name: 'penicilin', id: 2},
      {name: 'lipitor', id: 3}
    ]
    if params[:name].present?
      @drugs = @drugs.select{|d|d[:name].include? params[:name]}
    end
  end

end
