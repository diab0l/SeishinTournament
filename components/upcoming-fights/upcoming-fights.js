define(["text!./upcoming-fights.html"], function(view) {
  function init() {
    //var vm = new UpcomingFightsViewModel();

    window.setInterval(function () {
      $(".time-now")
        .text("Current time: " + new moment().format("HH:mm:ss G\\MTZ"));
    }, 1000);

    return view;
  }

  return init;
});
