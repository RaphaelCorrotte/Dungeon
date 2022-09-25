# frozen_string_literal: true

require File.expand_path("entity", File.dirname(__FILE__))

class Player < Entity
  attr_reader :step

  def initialize
    super(50, 50)
    @step = 5
  end

  def move_forward = @y -= @step
  def move_backward = @y += @step
  def move_right = @x += @step
  def move_left = @x -= @step
end
