require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @capacity = 8
    @length = 0
    @store = Array.new(@length)
  end

  # O(1)
  def [](index)
    if index > @length - 1
      raise "index out of bounds"
    else
      return @store[index]
    end
  end

  # O(1)
  def []=(index, value)
    if index > @capacity
      resize!
      @store[index] = value
      @length += 1
    else
      @store[index] = value
      @length += 1
    end
  end

  # O(1)
  def pop
    if @length == 0
      raise "index out of bounds"
    else
      result = @store[@length - 1]
      @store[@length - 1] = nil
      @length -= 1
      return result
    end
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if @length == @capacity

    @store[@length] = val
    @length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    if @length == 0
      raise "index out of bounds"
    else
      new_store = []
      @store.each_with_index do |el, idx|
        unless idx == 0
          new_store[idx - 1] = el
        end
      end
      @length -= 1
    end
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    resize! if @capacity == @length

    new_store = []
    @store.each_with_index do |el, idx|
      new_store[idx + 1] = el
    end

    @store = new_store
    @store[0] = val
    @length += 1
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    @capacity *= 2
    new_store = []
    @store.each_with_index do |el, idx|
      new_store[idx] = el
    end
    @store = new_store
  end
end
