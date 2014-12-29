Volant.GraphView = Ember.View.extend
  attributeBindings: ['width']
  templateName: 'graph'
  classNames: [ 'graph-view' ]

  didInsertElement: ->
    data = {
      labels: @get('data').applyFormCounts.currentYear.labels,
      datasets: [
        {
          label: "2013",
          fillColor: "rgba(220,220,220,0.5)"
          strokeColor: "rgba(220,220,220,0.8)"
          highlightFill: "rgba(220,220,220,0.75)"
          highlightStroke: "rgba(220,220,220,1)"
          data: @get('data').applyFormCounts.currentYear.data
        }
        {
          label: "2014",
          fillColor: "rgba(151,187,205,0.5)"
          strokeColor: "rgba(151,187,205,0.8)"
          highlightFill: "rgba(151,187,205,0.75)"
          highlightStroke: "rgba(151,187,205,1)"
          data: @get('data').applyFormCounts.lastYear.data
        }
      ]
    }

    # set same width as parent
    canvas = @$('canvas')[0]
    canvas.width = @$().width()
    canvas.height = 200
    opts = {scaleShowLabels: true }
    ctx = canvas.getContext("2d")
    chart = new Chart(ctx,opts).Bar(data)
    @$('.legend-container').append chart.generateLegend()
