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
    @rooms[@current_room] = Room.new(@current_room, **Hash[north: true, south: true, east: true, west: true])
    @player = Player.new
    @player.warp(250, 250)
  end

  def draw
    draw_rect(0, 0, Rules::WIDTH, Rules::HEIGHT, Gosu::Color::YELLOW)
    @player.draw(Rules.responsive(50, width), Rules.responsive(50, height))
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

  def draw_wall(cardinal_direction, open: false)
    raise ArgumentError, "Invalid cardinal direction: #{cardinal_direction}" unless %i[north south east west].include?(cardinal_direction.to_sym)

    coordinates = Hash[
      north: [Rules.responsive(30, width), Rules.responsive(30, height), Rules.responsive(470, width), Rules.responsive(30, height)],
      south: [Rules.responsive(30, width), Rules.responsive(470, height), Rules.responsive(470, width), Rules.responsive(470, height)],
      east: [Rules.responsive(470, width), Rules.responsive(30, height), Rules.responsive(470, width), Rules.responsive(470, height)],
      west: [Rules.responsive(30, width), Rules.responsive(30, height), Rules.responsive(30, width), Rules.responsive(470, height)]
    ]
    if open
      doors = Hash[
        north: [
          [Rules.responsive(200, width), Rules.responsive(30, height), Rules.responsive(200, width), 0],
          [Rules.responsive(300, width), Rules.responsive(30, height), Rules.responsive(300, width), 0]
        ],
        west: [
          [Rules.responsive(30, width), Rules.responsive(200, height), 0, Rules.responsive(200, height)],
          [Rules.responsive(30, width), Rules.responsive(300, height), 0, Rules.responsive(300, height)]
        ],
        south: [
          [Rules.responsive(200, width), Rules.responsive(470, height), Rules.responsive(200, width), Rules.responsive(500, height)],
          [Rules.responsive(300, width), Rules.responsive(470, height), Rules.responsive(300, width), Rules.responsive(500, height)]
        ],
        east: [
          [Rules.responsive(470, width), Rules.responsive(200, height), Rules.responsive(500, width), Rules.responsive(200, height)],
          [Rules.responsive(470, width), Rules.responsive(300, height), Rules.responsive(500, width), Rules.responsive(300, height)]
        ]
      ]
      walls = Hash[
        north: [
          [Rules.responsive(30, width), Rules.responsive(30, height), Rules.responsive(200, width), Rules.responsive(30, height)],
          [Rules.responsive(300, width), Rules.responsive(30, height), Rules.responsive(470, width), Rules.responsive(30, height)]
        ],
        west: [
          [Rules.responsive(30, width), Rules.responsive(30, height), Rules.responsive(30, width), Rules.responsive(200, height)],
          [Rules.responsive(30, width), Rules.responsive(300, height), Rules.responsive(30, width), Rules.responsive(470, height)]
        ],
        south: [
          [Rules.responsive(30, width), Rules.responsive(470, height), Rules.responsive(200, width), Rules.responsive(470, height)],
          [Rules.responsive(300, width), Rules.responsive(470, height), Rules.responsive(470, width), Rules.responsive(470, height)]
        ],
        east: [
          [Rules.responsive(470, width), Rules.responsive(30, height), Rules.responsive(470, width), Rules.responsive(200, height)],
          [Rules.responsive(470, width), Rules.responsive(300, height), Rules.responsive(470, width), Rules.responsive(470, height)]
        ]
      ]
      doors[cardinal_direction].each do |coordinate|
        Gosu.draw_line(coordinate[0], coordinate[1], Gosu::Color::WHITE, coordinate[2], coordinate[3], Gosu::Color::WHITE)
      end
      walls[cardinal_direction].each do |coordinate|
        Gosu.draw_line(coordinate[0], coordinate[1], Gosu::Color::WHITE, coordinate[2], coordinate[3], Gosu::Color::WHITE)
      end
    else
      Gosu.draw_line(coordinates[cardinal_direction][0], coordinates[cardinal_direction][1], Gosu::Color::WHITE, coordinates[cardinal_direction][2], coordinates[cardinal_direction][3],
                     Gosu::Color::WHITE)
    end
  end
end

Game.new.show
