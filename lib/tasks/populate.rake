task "populate_reference" => [:environment] do 
  # populate NADAC drug pricing data
  NadacService.read_workbook
end