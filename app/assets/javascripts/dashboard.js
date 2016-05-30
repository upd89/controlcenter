$(document).on("page:change", function(){
  var $placeholder = $("#systemChart"),
      total = $placeholder.data("total"),
      data = [
        {
          label: "OK",
          data: $placeholder.data("ok") / total,
          color: "#99DD58"
        }, {
          label: "In Progress",
          data: $placeholder.data("progress") / total,
          color: "#E9C46A"
        }, {
          label: "Updates available",
          data: $placeholder.data("warning") / total,
          color: "#E76F51"
        }
      ];

  if ( !$placeholder.length ) {
    //only valid on the dashboard!
    return;
  }

  function labelFormatter(label, series) {
    return "<div style='text-align:center; padding:2px; color:white;'>" + label + "<br/>" + Math.round(series.percent) + "%</div>";
  }

  $.plot('#systemChart', data, {
    series: {
      pie: {
        show: true,
        radius: 1,
        label: {
          show: true,
          radius: 3/5,
          formatter: labelFormatter,
          background: {
            opacity: 0.5,
            color: '#000'
          }
        }
      }
    },
    legend: {
      show: false
    }
  });
});
