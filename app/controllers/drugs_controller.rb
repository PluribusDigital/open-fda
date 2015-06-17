class DrugsController < ApplicationController
  
  def index
    @drugs = [
      {name: 'Prozac',    product_ndc: '16590-843'},
      {name: 'Viagra',    product_ndc: '55289-524'},
      {name: 'Atripla',   product_ndc: '24236-292'}
    ]
    if params[:name].present?
      @drugs = @drugs.select{|d|d[:name].include? params[:name]}
    end
  end

  def show
    @drug = LabelService.product_ndc_search params[:id]
    render json: @drug
  end 

end
