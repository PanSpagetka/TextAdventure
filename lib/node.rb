#!/usr/bin/env ruby -wKU
require "ostruct"

class Node < OpenStruct

  def initialize(parent, options = {})
    super()
    options['contains'] ||= {}
    options.each {|k,v| send("#{k}=", v) unless k == 'contains' }

    self.parent = parent
    self.parent.children << self unless parent.nil?
    self.children = []
    options['contains'].each do |node|
      klass = Object::const_get(node['type'].capitalize)
      klass.new(self, node)
    end
  end

  def moveNode(to)
    return false unless self.movable
    return false if self.parent.nil? && !self.parent&.children.nil?
    self.parent.children -= [self] unless self.parent&.children.nil?
    self.parent = to
    to.children.push self
    true
  end

  def deleteNode
    return false if parent.nil?
    children.each do |c|
      c.parent = parent
    end
    parent.children -= [self] unless parent&.children.nil?
    true
  end

  def findNodeWithName(name, start)
    return start if start.name == name
    start.children.each do |c|
      node = findNodeWithName(name, c)
      return node unless node.nil?
      node
    end
    node
  end

  def findItemInRoom(item, room)
    return room if room.name == item
    return room.parent if room.parent&.name == item
    room.children.each do |c|
      node = findItemInRoom(item, c) if c.type == 'Item'
      return node unless node.nil?
      node
    end
    node
  end

  def findEnterableNodes
    rooms = []
    rooms += getLeadingNodes(self.parent) if self.parent&.enterable
    self.children.each do |c|
      if c.enterable
        rooms += getLeadingNodes(c)
      end
    end
    rooms
  end

  def getLeadingNodes(node)
    if node.type == 'Room'
      [node]
    elsif node.type == 'Item'
      if node.open
        node.leads
      else
        []
      end
    end
  end

  def description
    descs = children.collect do |c|
      ret = c.name
      ret = c['short_description'] if c['short_description']
      ret = nil if c.type == 'Player' || !c.movable || c.hidden
      ret
    end
    descs.delete(nil)
    if descs.empty?
      return "#{self['description']}"
    end
    "#{self['description']}. Also you can find: #{descs.join(', ')}"
  end
end
