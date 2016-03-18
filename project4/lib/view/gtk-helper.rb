module GtkHelper
  
  # type = 'V' or 'H' for a vertical or horizontal box
  # elements is list of hashes with each hash format:
=begin
       {
          :type => Gtk::Button,
          :content => "Start Game!",
          :listeners => [
            { 
              :event => :clicked, 
              :action => Proc.new {someHandler} 
            }
          ]
        }
=end
  # or like this
=begin
        {
          :widget => anyInitializedGtkWidget
        }
=end
  def self.createBox(type, elements)
    box = nil
    
    if type == 'V'
      box = Gtk::VBox.new
    else
      box = Gtk::HBox.new
    end
    
    elements.each do |element|
      box.pack_start self.createElement(element)
    end
    
    return box
  end
  
  def self.createElement(element)
    if element[:widget]
      return element[:widget]
    end
    
    el = element[:type].new(element[:content])
    if element[:listeners]
      element[:listeners].each do |listener|
        el.signal_connect(listener[:event]) {listener[:action].call}
      end
    end
    return el
  end
  
  def applyEventHandler (widget, event, &handler)
    
  end
  
end