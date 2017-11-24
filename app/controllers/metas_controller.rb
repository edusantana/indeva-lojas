class MetasController < ApplicationController
  
  before_action :set_loja
  
  def index
    @metas = @loja.metas
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loja
      @loja = Loja.find(params[:loja_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def loja_params
      params.require(:loja_id) #.permit(:nome)
    end

end
