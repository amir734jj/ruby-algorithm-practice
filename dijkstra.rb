class Node
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def to_s
    @name
  end
end

class Edge
  attr_accessor :from, :to, :distance

  def initialize(from, to, distance)
    @from = from
    @to = to
    @distance = distance
  end

  def to_s
    from.to_s + ' -> ' + to.to_s + " (#{distance.to_s})"
  end
end

def find_neighbors(node, edges)
  neighbors = []

  edges.each do |edge|
    if edge.from == node
      neighbors.push(edge.to)
    elsif edge.to == node
      neighbors.push(edge.from)
    end
  end

  neighbors
end

def find_edge(node1, node2, edges)
  edges.find {|edge| (edge.from == node1 && edge.to == node2) || edge.from == node2 && edge.to == node1}
end

def dijkstra_shortest_path(start, finish, vertices, edges)
  weights = {}
  visited = []
  vertices.each {|node| weights[node] = +1.0 / 0.0}
  weights[start] = 0
  heap = [start]
  previous_of = {}
  invalid_routes = []

  until heap.empty?
    node = heap.min_by {|node| weights[node]}
    heap.delete(node)
    visited.push(node)
    neighbors = find_neighbors(node, edges) - visited
    initial_value = weights[node]

    neighbors.each do |item|
      edge = find_edge(node, item, edges)
      if !edge.nil? && initial_value + edge.distance < weights[item]
        weights[item] = initial_value + edge.distance
        heap.push(item)
        previous_of[item] = node
      else
        invalid_routes.push(edge)
      end
    end
  end

  current = finish
  path = []
  loop do
    next_current = previous_of[current]
    path = [find_edge(current, next_current, edges)] + path
    current = next_current

    break if current == start
  end

  [path, weights[finish]]
end

a = Node.new('A')
b = Node.new('B')
c = Node.new('C')
d = Node.new('D')
e = Node.new('E')
f = Node.new('F')
g = Node.new('G')

vertices = [a, b, c, d, e, f, g]

edges = [
    Edge.new(a, b, 4),
    Edge.new(a, c, 3),
    Edge.new(a, e, 7),
    Edge.new(b, d, 5),
    Edge.new(b, c, 6),
    Edge.new(c, d, 11),
    Edge.new(c, e, 8),
    Edge.new(e, d, 2),
    Edge.new(e, g, 5),
    Edge.new(d, g, 10),
    Edge.new(d, f, 2),
    Edge.new(g, f, 2)
]

puts dijkstra_shortest_path(a, f, vertices, edges)
