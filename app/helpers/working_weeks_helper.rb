module WorkingWeeksHelper

  def fetch_procedure_types
    procs = ProcedureType.select(:id, :procedure_type_name).as_json
  end

end
