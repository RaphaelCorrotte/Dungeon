# frozen_string_literal: true

class Player
  def initialize
    @x = @y = 0.0
  end

  def warp(x, y)
    @x = x
    @y = y
  end

  def move_forward = @y -= 5
  def move_backward = @y += 5
  def move_right = @x += 5
  def move_left = @x -= 5

  def draw(width, height)
    Gosu.draw_rect(@x, @y, width, height, Gosu::Color::FUCHSIA)
  end
end
