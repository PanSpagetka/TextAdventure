require 'graph'

def getEdges(root)
  edges = []
  root.children.each do |c|
    edges.push([root.name, c.name])
    edges.concat(getEdges(c))
  end
  edges
end

def drawGraph(root)
  edges = getEdges(root)
    digraph do
      edges.each do |e|
        edge e[0], e[1]
      end
      save "simple_example", "png"
    end
    ''
end
