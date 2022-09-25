# frozen_string_literal: true

require File.expand_path("rules", File.dirname(__FILE__))

class Entity
  attr_reader :height, :width
  attr_accessor :x, :y

  def initialize(width, height)
    @width = width
    @height = height
    @x = @y = 0.0
  end

  def warp(x, y)
    @x = x
    @y = y
  end

  def collision?(entity)
    raise "Entity must be a subclass of Entity" unless entity.is_a?(Entity) || !entity.respond_to?(:box)

    if (Rules.compare(box[0],
                      entity.box[0]) < (@width) && Rules.compare(box[1],
                                                                 entity.box[1]) < (@height)) || (Rules.compare(box[2], entity.box[2]) < (@width) && Rules.compare(box[3], entity.box[3]) < (@height))
      true
    else
      false
    end
  end

  def box
    [
      @x - (@width / 2), # Begin x
      @y - (@height / 2), # Begin y
      @x + (@width / 2), # End x
      @y + (@height / 2) # End y
    ]
  end

  def draw
    Gosu.draw_rect(@x - (@width / 2), @y - (@height / 2), @width, @height, Gosu::Color::FUCHSIA)
  end
end
