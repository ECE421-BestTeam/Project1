require 'gtk2'

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
        self.applyEventHandler(el, listener[:event]) {listener[:action].call}
      end
    end
    return el
  end
  
  
  def self.applyEventHandler(widget, event, &handler)
    widget.signal_connect(event) do |*args, &block|
      begin
        handler.call(*args, &block)
      rescue Exception => e
        self.errorHandler(e)
      end
    end
  end
  
  def self.errorHandler(err)
    self.popUp("Error", err)
  end
  
  def self.popUp(title, err, exitCallback = Proc.new {})
    Gtk.init
    @window = Gtk::Window.new
    @window.signal_connect("destroy") do
      exitCallback.call
      Gtk.main_quit
    end
    @window.title = title
        
    @window.add Gtk::Label.new(err.to_s)
    @window.show_all
    
    Gtk.main
  end
  
end
