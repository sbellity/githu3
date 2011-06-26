module Githu3
  class Store
  
    attr_reader :id
  
    def initialize data
      @id = data[:id] || data["id"]
      @attributes = OpenStruct.new(data)
    end
  
    def method_missing m, *args
      @attributes.send m, *args
    end
  
  end
end