define(['components/overview.upcoming-fights.js'],
  function(upcomingFights) {

  $(function() {
    var main = $("#main");
    main.html(upcomingFights());
  });
});
