define(['components/upcoming-fights/upcoming-fights.js'],
  function(upcomingFights) {

  //var UpcomingFightsViewModel = require(['vm/UpcomingFightsViewModel']);
  //var TournamentViewModel = require(['vm/TournamentViewModel']);
  //var MatViewModel = require(['vm/MatViewModel']);
  //var FightViewModel = require(['vm/FightViewModel']);
  //var FighterViewModel = require(['vm/FighterViewModel']);

  $(function() {
    var main = $("#main");
    main.html(upcomingFights());
  });
});
