class Player < Node

  ACTIONS = ['take', 'put', 'look', 'go', 'open', 'close', 'unlock', 'eat', 'help']

  def actions
    ACTIONS
  end

  def initialize(parent, options = {})
    options[:type] = 'Player'
    options[:movable] = true
    super
    @alive = true
  end

  def alive?
    @alive
  end

  def take(*proposition, item)
    ret = false
    if item
      i = findNodeWithName(item, parent)
      return "You can't find #{item}." if i.nil?
      ret = i.moveNode(self)
    end

    return "You have succesfully taken #{item}." if ret
    "You cant take #{item}."
  end

  def put(what, *proposition, where)
    if what && where
      item = findNodeWithName(what, self)
      return "You dont have #{what}." if item.nil?
      target = self.findNodeWithName(where, parent)
      return "There is no #{where} to put it." if target.nil?

      ret = item.moveNode(target)
      return  "You have succesfully put #{what} #{proposition.join(' ')} #{where}." if ret
      "You cant put #{what} #{proposition.join(' ')} #{where}."
    end
  end


  def look(*proposition, target)
    return 'Look at what?' if target.nil?
    target = parent.name if target == 'around'
    item = findItemInRoom(target, parent)
    return "There is #{item.name}. #{item.description}." if item
    "You cant find such item like #{item.name}."
  end

  def go(*where)
    return 'Where you want to go?' if where.empty?
    rooms = parent.findEnterableNodes
    rooms.push(parent)
    name = where.join(' ')
    loop do
      rooms.each do |room|
        if room.name == name
          return "You are already in #{name}." if name == parent&.name
          enter(room)
          return "You have entered #{name}."
        end
      end
      where.shift
      name = where.join(' ')
      return 'Cant go there.' if where.empty?
    end
  end

  def open(*proposition, target)
    return 'What you want to open?' if target.empty?
    item = findItemInRoom(target, parent)
    if item
      if item.locked == true
        "#{target} is locked."
      elsif item.openable
        item.open = true
        item.instance_eval(&item.on_open) if item.on_open
        "You have succesfully opened #{target}."
      else
        "You can't open #{target}."
      end
    else
      "There is no such item as #{target}"
    end
  end

  def close(*proposition, target)
    return 'What you want to close?' if target.empty?
    item = findItemInRoom(target, parent)
    if item
      if item.openable
        item.open = false
        item.instance_eval(&item.on_close) if item.on_close
        "You have succesfully closed #{target}."
      else
        "You can't close #{target}."
      end
    else
      "There is no such item as #{target}"
    end
  end

  def unlock(*proposition, target)
    return 'What you want to unlock?' if target.empty?
    item = findItemInRoom(target, parent)
    if item
      if item.locked
        if haskey?
          item.locked = false
          item.instance_eval(&item.on_unlock) if item.on_unlock
          "You have succesfully unlocked #{target}."
        else
          'You need key.'
        end
      else
        "#{target} is not locked."
      end
    else
      "There is no such item as #{target}."
    end
  end

  def eat(*proposition, target)
    return 'What you want to eat?' if target.empty?
    item = findItemInRoom(target, parent)
    if item.eatable
      item.instance_eval(&item.on_eat) if item.on_eat
    else
      "There is no such item as #{target}."
    end
  end

  def enter(where)
    if where.type == 'Room'
      where.instance_eval(&where.on_enter) if where.on_enter
      moveNode(where)
    end
  end

  def haskey?
    !!findNodeWithName('key', self)
  end

  def help
    "Welcome in GAME. You control your action by typing commands. Try to use simple sentences. Command allways start with verb, ends with target typically with noun. Here is list of availiable verbs: #{actions}."
  end

  def handle(action, *params)
    begin
      self.send(action.to_sym, *params)
    rescue ArgumentError => e
      ARGUMENT_ERRORS[action].each do |e|
        ret = e.call(params.count)
        return ret unless ret.nil?
      end
      "You cant use #{action} like this. You might want to specify target."
    end
  end

  ARGUMENT_ERRORS = {
    :take => [Proc.new {|n| "Take what?" if n == 0 }],
    :put => [Proc.new {|n| "Put what?" if n == 0 }, Proc.new {|n| "Put where?" if n == 1}],
    :look => [Proc.new {|n| "Look at what?" if n == 0 }],
    :open => [Proc.new {|n| "Open what?" if n == 0 }],
    :close => [Proc.new {|n| "Close what?" if n == 0 }],
    :unlock => [Proc.new {|n| "Unlock what?" if n == 0 }],
    :eat => [Proc.new {|n| "Eat what?" if n == 0 }],
            }
end
