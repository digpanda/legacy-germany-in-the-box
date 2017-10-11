class Chart < BaseService
  class Line
    attr_reader :chart, :color, :label, :fill, :positions, :values

    def initialize(chart, color:, label:, fill:false)
      @chart = chart
      @color = color
      @label = label
      @fill = fill
      @values = []
      @positions = {}
    end

    def store
      chart.entries << { positions: positions, dataset: dataset }
      chart
    end

    def dataset
      {
        label: label,
        borderColor: end_color,
        fill: fill
      }
    end

    def end_color
      if color == :blue
        "#3e95cd"
      end
    end

    def data(position:, value:)
      @positions[position] = value
      self
    end
  end
end
