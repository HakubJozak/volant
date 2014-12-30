Volant.GraphView = Ember.View.extend
  templateName: 'graph'
  classNames: [ 'graph-view' ]

  didInsertElement: ->
    # set same width as parent
    console.log 'Inserting graph element'
    canvas = @$('canvas')[0]
    canvas.width = @$().width()
    canvas.height = 200
    @renderChart(@get('data'))

  # refreshData: (->
  #   console.log 'Redrawing graph'
  #   @get('data').then (data) =>
  #     @renderChart(data)
  # ).observes('data')

  renderChart: (data) ->
    counts = data.applyFormCounts
    datasets = {
      labels: counts.currentYear.labels,
      datasets: [
        {
          label: counts.lastYear.title,
          fillColor: "rgba(220,220,220,0.5)"
          strokeColor: "rgba(220,220,220,0.8)"
          highlightFill: "rgba(220,220,220,0.75)"
          highlightStroke: "rgba(220,220,220,1)"
          data: counts.lastYear.data
        }
        {
          label: counts.currentYear.title,
          fillColor: "rgba(151,187,205,0.5)"
          strokeColor: "rgba(151,187,205,0.8)"
          highlightFill: "rgba(151,187,205,0.75)"
          highlightStroke: "rgba(151,187,205,1)"
          data: counts.currentYear.data
        }
      ]
    }

    canvas = @$('canvas')[0]
    ctx = canvas.getContext("2d")
    @chart.destroy() if @chart
    @chart = new Chart(ctx).Bar(datasets)

    @$('.legend-container').find('ul').remove()
    @$('.legend-container').append @chart.generateLegend()
