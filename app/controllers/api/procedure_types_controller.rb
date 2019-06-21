class Api::ProcedureTypesController < ApplicationController

  def fetch_procedure_types
    pt = ProcedureType.all
    kinds = ProcedureType.kinds
    @hash_to_send = {}
    kinds.each do |kind_key, kind_value|
      @hash_to_send[kind_value] = {p_kind: kind_key, procedures: pt.where(kind: kind_key.to_sym).select(:id, :procedure_type_name)}
    end
    render json: @hash_to_send.to_json
  end

end
