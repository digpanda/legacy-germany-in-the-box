class Chart < BaseService

  # Chart.new(title: 'Title')
  # .line(color: :blue, label: 'Label').data(position: 'Week 1', value: 90).store
  # chart.render

  attr_reader :title, :entries, :type

  def initialize(title:)
    @title = title
    @entries = []
    @type = :unknown
  end

  def render
    {
      type: type,
        data: {
          labels: positions, # it's y axis ['10', '20']
          datasets: datasets # each line
        },
        options: {
          title: {
            display: true,
            text: title
          }
        }
    }
  end

  def positions
    entries.reduce([]) do |acc, entry|
      acc << entry[:positions].keys
    end.sort{|a,b| a <=> b }.flatten.uniq
  end

  def datasets
    entries.reduce([]) do |acc, entry|
      # add data attribute to the system
      acc << entry[:dataset].merge({ data: solve_data(entry) })
    end
  end

  def solve_data(entry)
    positions.reduce([]) do |acc, position|
      acc << (entry[:positions][position] || 0) # if nil we still set something
    end
  end

  def line(*args)
    @type = :line
    Chart::Line.new(self, *args)
  end

end
