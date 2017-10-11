class Api::Admin::ChartsController < Api::ApplicationController
  authorize_resource class: false

  def total_users
    render status: :ok,
          json: { success: true, data: total_users_hash }.to_json
  end

  private

    # NOTE : need to make a service for this.
    def total_users_hash

      chart = Chart.new(title: 'Title')
      line = chart.line(color: :blue, label: 'Label 1')
      line.data(position: 'Week 1', value: 20).data(position: 'Week 3', value: 20)
      line.store
      line = chart.line(color: :blue, label: 'Label 2')
      line.data(position: 'Week 0', value: 15).data(position: 'Week 2', value: 30)
      line.store
      chart.render
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
    end
end
