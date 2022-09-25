# frozen_string_literal: true

require "gosu"
require File.expand_path("classes/rules", File.dirname(__FILE__))
require File.expand_path("classes/room", File.dirname(__FILE__))
require File.expand_path("classes/player", File.dirname(__FILE__))

class Game < Gosu::Window
  attr_reader :rooms, :current_room

  def initialize
    super(Rules::WIDTH, Rules::HEIGHT)
    @current_room = [0, 0]
    @rooms = Class.new(Hash) do
      def [](key)
        key.is_a?(Array) ? self[key.join(":").to_sym] : super(key)
      end

      def []=(key, value)
        key.is_a?(Array) ? self[key.join(":").to_sym] = value : super(key, value)
      end
    end.new
    @rooms[@current_room] = Room.new(@current_room, **Hash[north: false, south: true, east: true, west: true])
    @player = Player.new
    @second = Player.new
    @second.warp(100, 100)
    @player.warp(250, 250)
  end

  def draw
    @player.draw
    @second.draw
    draw_room(rooms[@current_room])
  end

  def update
    @player.move_forward if button_down?(Gosu::KB_UP)
    @player.move_backward if button_down?(Gosu::KB_DOWN)
    @player.move_left if button_down?(Gosu::KB_LEFT)
    @player.move_right if button_down?(Gosu::KB_RIGHT)
  end

  def draw_room(room)
    %i[north south east west].each do |cardinal|
      draw_wall(cardinal, open: room.method(:"#{cardinal}?").call)
    end
  end

  def draw_wall(cardinal, open:); end

  def resize(width, height)
    self.resizable = true
    self.width = width
    self.height = height
    self.resizable = false
  end
end

Game.new.show
