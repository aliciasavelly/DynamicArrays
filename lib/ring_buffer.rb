require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @capacity = 8
    @store = Array.new(@capacity)
    @length = 0
    @start_idx = 0
  end

  # O(1)
  def [](index)
    if index > @length || index == @length
      raise "index out of bounds"
    else
      @store[(index + @start_idx) % @capacity]
    end
  end

  # O(1)
  def []=(index, val)
    if index > @length || index == @length
      raise "index out of bounds"
      return
    end
    
    @store[(index + @start_idx) % @capacity] = val
  end

  # O(1)
  def pop
    if @length == 0
      raise "index out of bounds"
      return
    end

    result = (@start_idx + @length) % @capacity - 1
    @store[(@start_idx + @length) % @capacity - 1] = nil
    @length -= 1
    result
  end

  # O(1) ammortized
  def push(val)
    resize! if @length == @capacity

    @store[(@length + @start_idx) % @capacity] = val
    @length += 1
  end

  # O(1)
  def shift
    if @length == 0
      raise "index out of bounds"
      return
    end

    result = @store[@start_idx]
    @store[@start_idx] = nil
    @start_idx = (@start_idx + 1) % @capacity
    @length -= 1
    result
  end

  # O(1) ammortized
  def unshift(val)
    resize! if @length == @capacity

    @start_idx = (@start_idx - 1) % @capacity
    @store[@start_idx] = val
    @length += 1
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
  end

  def resize!
    old_cap = @capacity
    @capacity *= 2
    @start_idx == 0 ? new_start_idx = 0 : new_start_idx = (@start_idx + old_cap)
    new_store = Array.new(@capacity)

    @store.each_with_index do |el, idx|
      if ((idx + new_start_idx) % @capacity) >= @start_idx
        new_store[idx] = el
      else
        new_store[idx + old_cap] = el
      end
    end

    @store = new_store
    @start_idx = new_start_idx
  end
end
