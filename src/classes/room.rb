# frozen_string_literal: true

class Room
  attr_reader :x, :y, :connexions

  def initialize(coordinates, north: false, south: false, east: false, west: false)
    @x = coordinates[0]
    @y = coordinates[1]
    @connexions = Hash[
      north: !north.nil?,
      south: !south.nil?,
      east: !east.nil?,
      west: !west.nil?
    ]
    @connexions.each_key do |cardinal|
      define_singleton_method("#{cardinal}?") { !!@connexions[cardinal] }
      define_singleton_method("close_#{cardinal}") { @connexions[cardinal] = false }
      define_singleton_method("open_#{cardinal}") { @connexions[cardinal] = true }
    end
  end

  def key
    "#{@x}:#{@y}"
  end

  def self.from(key)
    Room.new(key.split(":").map(&:to_i))
  end
end
