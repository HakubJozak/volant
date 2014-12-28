Volant.GraphView = Ember.View.extend
  tagName: 'canvas'
  attributeBindings: ['width']

  didInsertElement: ->
    data = {
      labels: @get('data').recentApplyForms.labels,
      datasets: [
        # {
        #   fillColor: "rgba(220,220,220,0.5)",
        #   strokeColor: "rgba(220,220,220,1)",
        #   pointColor: "rgba(220,220,220,1)",
        #   pointStrokeColor: "#fff",
        #   data: [65,59,90,81,56,55,40]
        # },
        {
          fillColor : "rgba(151,187,205,0.5)",
          strokeColor : "rgba(151,187,205,1)",
          pointColor : "rgba(151,187,205,1)",
          pointStrokeColor : "#fff",
          data: @get('data').recentApplyForms.data
        }
      ]
    }

    # set same width as parent
    canvas = @$()[0]
    canvas.width = @$().parent().width()
    canvas.height = 200
    ctx = @$().get(0).getContext("2d")
    chart = new Chart(ctx).Line(data)
