class Chart < BaseService

  # Chart.new(title: 'Title')
  # .line(color: :blue, label: 'Label').data(position: 'Week 1', value: 90).store
  # chart.render

  attr_reader :title, :type, :entries, :vertical_label

  def initialize(title:, type: :line, vertical_label: nil)
    @title = title
    @type = type
    @entries = []
    @vertical_label = vertical_label
  end

  def draw(*args)
    Chart::Draw.new(self, *args)
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
          },


          scales: {
            # xAxes: [{
            #   type: 'time',
            #   distribution: 'series',
            #   ticks: {
            #     source: 'labels'
            #   }
            #   }],
              yAxes: [{
                scaleLabel: {
                  display: true,
                  labelString: vertical_label
                }
                }]
              }


        }
    }
  end

  def positions
    entries.reduce([]) do |acc, entry|
      acc << entry[:positions].keys
    end.flatten.sort{|a,b| a <=> b }.uniq
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
end
# {
#   type: 'line',
#     data: {
#       labels: [1500,1600,1700,1750,1800,1850,1900,1950,1999,2050],
#       datasets: [{
#           data: [86,114,106,106,107,111,133,80,783,2478],
#           label: "Africa",
#           borderColor: "#3e95cd",
#           fill: false
#         }, {
#           data: [282,350,411,502,635,809,947,1402,3700,5267],
#           label: "Asia",
#           borderColor: "#8e5ea2",
#           fill: false
#         }, {
#           data: [168,170,178,190,203,276,408,547,675,734],
#           label: "Europe",
#           borderColor: "#3cba9f",
#           fill: false
#         }, {
#           data: [40,20,10,16,24,38,74,167,508,784],
#           label: "Latin America",
#           borderColor: "#e8c3b9",
#           fill: false
#         }, {
#           data: [6,3,2,2,7,26,82,172,312,433],
#           label: "North America",
#           borderColor: "#c45850",
#           fill: false
#         }
#       ]
#     },
#     options: {
#       title: {
#         display: true,
#         text: 'World population per region (in millions)'
#       }
#     }
# }
