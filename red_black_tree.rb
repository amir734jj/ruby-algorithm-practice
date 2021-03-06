:BLACK
:RED

class Node
  attr_accessor :value, :color, :parent, :left, :right

  def initialize(value, color, parent, left, right)
    @value = value
    @color = color
    @parent = parent
    @left = left
    @right = right
  end

  def is_leaf?
    left.nil? && right.nil?
  end

  def to_s
    if value.nil?
      ''
    else
      str = value.to_s
      unless is_leaf?
        unless left.nil?
          str = "(#{left.to_s})#{str}"
        end

        unless right.nil?
          str = "#{+str}(#{right.to_s})"
        end
      end
      str
    end
  end
end

class RedBlackTree
  # static variable
  @@nil_leaf = Node.new(nil, nil, nil, nil, nil)

  attr_accessor :count, :root

  def initialize
    @count = 0
    @root = nil
  end

  def add(value)
    if @root.nil?
      @root = Node.new(value, :BLACK, nil, @@nil_leaf, @@nil_leaf)
    else
      parent, direction = find_parent value

      new_node = Node.new(value, :RED, parent, @@nil_leaf, @@nil_leaf)
      if direction == :LEFT
        parent.left = new_node
      else
        parent.right = new_node
      end

      try_rebalance new_node
    end

    @count += 1
  end

  def try_rebalance(new_node)
    parent = new_node.parent

    unless parent.nil? || parent == root || parent.color != :RED
      grand_parent = parent.parent
      direction = parent.value > new_node.value ? :LEFT : :RIGHT
      parent_direction = grand_parent.value > parent.value ? :LEFT : :RIGHT
      uncle = parent_direction == :LEFT ? grand_parent.right : grand_parent.left

      if uncle == @@nil_leaf || uncle.color == :BLACK
        if [direction, parent_direction] == %i[LEFT LEFT]
          # LL => Right rotation
          right_rotation(new_node, parent, grand_parent, true)
        elsif [direction, parent_direction] == %i[RIGHT RIGHT]
          # RR => Left rotation
          left_rotation(new_node, parent, grand_parent, true)
        elsif [direction, parent_direction] == %i[LEFT RIGHT]
          # LR => Right rotation, left rotation
          right_rotation(nil, new_node, parent, false)
          # due to the right rotation, parent and new_node positions have switched
          left_rotation(parent, new_node, grand_parent, true)
        elsif [direction, parent_direction] == %i[RIGHT LEFT]
          # RL => Left rotation, right rotation
          left_rotation(nil, new_node, parent, false)
          # due to the left rotation, parent and new_node positions have switches
          right_rotation(parent, new_node, grand_parent, true)
        end
      else
        # uncle is red, simply recolor
        recolor(grand_parent)
      end
    end
  end

  # recolors the grandfather red, coloring his children black
  def recolor(grandfather)
    grandfather.left.color = :BLACK
    grandfather.right.color = :BLACK
    if @root != grandfather
      grandfather.color = :RED
    end

    try_rebalance grandfather
  end

  # finds a place for the value in the binary tree, returning the node and
  # the direction it should go in
  def find_parent(value)
    find = lambda do |node|
      if value < node.value
        # go left
        if node.left.color.nil?
          # no more to go
          [node, :LEFT]
        else
          find.call node.left
        end
      elsif value > node.value
        # go right
        if node.right.color.nil?
          # no more to go
          [node, :RIGHT]
        else
          find.call node.right
        end
      end
    end

    find.call @root
  end

  # right rotation of the tree
  def right_rotation(node, parent, grand_parent, to_recolor)
    grand_grand_parent = grand_parent.parent
    # grandfather will become the right child of parent
    update_parent(parent, grand_parent, grand_grand_parent)

    old_right = parent.right
    parent.right = grand_parent
    grand_parent.parent = parent
    grand_parent.left = old_right
    old_right.parent = grand_parent

    # recolor the nodes after a move to preserve invariants
    if to_recolor
      parent.color = :BLACK
      node.color = :RED
      grand_parent.color = :RED
    end
  end

  def left_rotation(node, parent, grand_parent, to_recolor)
    grand_grand_parent = grand_parent.parent
    # grandfather will become the left child of parent
    update_parent(parent, grand_parent, grand_grand_parent)

    old_left = parent.left
    parent.left = grand_parent
    grand_parent.parent = parent
    grand_parent.right = old_left
    old_left.parent = grand_parent

    if to_recolor
      parent.color = :BLACK
      grand_parent.color = :RED
      node.color = :RED
    end
  end

  # our node 'switches' place with the old child, assigning a new parent to the node
  # if the new_parent is NIL, this means that our node becomes the root of the tree
  def update_parent(node, parent_old_child, new_parent)
    node.parent = new_parent
    if !new_parent.nil?
      # determine the old child's position to put the node there
      if new_parent.value > parent_old_child.value
        new_parent.left = node
      else
        new_parent.right = node
      end
    else
      @root = node
    end
  end

  def to_s
    @root.to_s
  end
end

tree = RedBlackTree.new
tree.add(1)
tree.add(3)
tree.add(5)
print tree
