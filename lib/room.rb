class Room < Node

  def initialize(parent, options = {})
    options['type'] = 'Room'
    options['movable'] = false if options['movable'].nil?
    options['enterable'] = true if options['enterable'].nil?
    options['open'] = false if options['enterable'].nil?
    options['openable'] = false if options['enterable'].nil?
    options['locked'] = false if options['enterable'].nil?
    options['eatable'] = false if options['enterable'].nil?
    super
  end
end
