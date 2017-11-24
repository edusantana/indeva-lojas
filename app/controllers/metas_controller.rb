class MetasController < ApplicationController
  
  before_action :set_loja
  before_action :set_meta, only: [:show]
  
  def index
    @metas = @loja.metas
  end

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loja
      @loja = Loja.find(params[:loja_id])
    end
    def set_meta
      @meta = Meta.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def loja_params
      params.require(:loja_id, :id) #.permit(:nome)
    end

end
