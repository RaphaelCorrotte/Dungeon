# frozen_string_literal: true

# frozen_string_literal

class Rules
  WIDTH = 500
  HEIGHT = WIDTH
  def self.responsive(coordinate, width_or_height)
    (width_or_height * coordinate / WIDTH).floor
  end
end
