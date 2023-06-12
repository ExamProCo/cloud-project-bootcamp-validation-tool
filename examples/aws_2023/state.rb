class Aws2023::State
  attr_accessor :results,
                :manifest,
                :specific_params,
                :vpc_id,
                :public_subnet_id_1,
                :public_subnet_id_2,
                :public_subnet_id_3,
                :igw_id,
                :pipeline_name

  def initialize
    @results = {}
    @specific_params = nil
  end

  def process klass:, function_name:, input_params: [], output_params: []
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


    data = klass.send(function_name, **arguments)
    output_params.each do |param|
      puts "assigning output param: #{param}: #{data[param]}"
      send("#{param}=", data[param])
    end
    @results[function_name] = data[:result]
  end
end