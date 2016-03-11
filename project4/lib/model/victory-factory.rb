require_relative './victory-normal'
require_relative './victory-otto'


# produces the desired victory object
class VictoryFacotry
  
  # victoryType - number: 1 = normal, 2 = OTTO
  def initialize (victoryType)
    
    case victoryType
      when 1
        return VictoryNormal.new
      when 2
        return VictoryOtto.new
    end
    
  end
  
end

