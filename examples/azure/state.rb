class Azure::State
  attr_accessor :results,
                :manifest,
                :specific_params

  def initialize
    @results = {}
    @specific_params = nil
  end

  # klass: The class that has the validator
  # function_name: The function name we will dynamically call
  # input_params: pass these values in from the state file as parameters
  # output_params: set these values from the returned payload into the statefile
  # override_params: pass the param and value but not from the state file
  def process(
    klass:, 
    function_name:, 
    input_params: [], 
    output_params: [],
    override_params: {},
    rule_name: nil
  )
    arguments = {
      manifest: self.manifest,
      specific_params: specific_params
    }

    input_params.each do |param|
      unless send(param)
        puts "failed to run #{klass}.#{function_name} because #{param} was false"
      end
      arguments[param] = send(param)
    end

    override_params.each{|k,v| arguments[k] = v}

    raise "#{klass}: expected '#{function_name}' function to exist" unless klass.respond_to?(function_name.to_sym)

    data = klass.send(function_name, **arguments)
    output_params.each do |param|
      puts "assigning output param: #{param}: #{data[param]}"
      send("#{param}=", data[param])
    end
    rule_name ||= function_name

    raise "#{rule_name}: no data returned" if data.nil?
    raise "#{rule_name}: no data with result returned" unless data.key?(:result)
    @results[rule_name] = data
  end # def process
end