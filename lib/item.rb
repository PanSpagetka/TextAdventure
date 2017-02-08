class Item < Node

  def initialize(parent, options = {})
    options['type'] = 'Item'
    options['movable'] = true if options['movable'].nil?
    options['enterable'] = false if options['enterable'].nil?
    options['open'] = false if options['enterable'].nil?
    options['openable'] = false if options['enterable'].nil?
    options['locked'] = false if options['enterable'].nil?
    options['eatable'] = false if options['enterable'].nil?
    options['hidden'] = false if options['hidden'].nil?
    super
  end

  def leads
    rooms = []
    self.leadsto.each do |name|
      rooms.push(findNodeWithName(name, self.parent))
    end
    rooms
  end
end
