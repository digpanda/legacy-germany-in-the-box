class Chart < BaseService
  class Draw
    attr_reader :chart, :color, :label, :fill, :positions, :values, :type

    def initialize(chart, color:, label:, fill: false, type: nil)
      @chart = chart
      @color = color
      @label = label
      @fill = fill
      @values = []
      @positions = {}
      # we can specify types for each line / drawing in a mixed chart
      @type = type || chart.type
    end

    def store
      chart.entries << { positions: positions, dataset: dataset }
      chart
    end

    def dataset
      {
        label: label,
        type: type,
        borderColor: border_color,
        backgroundColor: background_color,
        fill: fill
      }
    end

    def border_color
      case color
      when :blue
        '#3e95cd'
      when :purple
        '#8e5ea2'
      when :green
        '#3cba9f'
      when :red
        '#c45850'
      when :light
        '#ffffff'
      else
        '#000000'
      end
    end

    def background_color
      case color
      when :blue
        'rgba(52,152,219, 0.50)'
      when :purple
        'rgba(142,94,162, 0.50)'
      when :green
        'rgba(60,186,159, 0.50)'
      when :red
        'rgba(255, 99, 132, 0.50)'
      when :light
        'rgba(0,0,0, 0.10)'
      else
        'rgba(0,0,0, 0.50)'
      end
    end

    def data(position:, value:)
      @positions[position] = value
      self
    end
  end
end
