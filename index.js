define(['components/overview/js?'],
  function(Overview) {

  $(function() {
    var main = $("#main");
    var overview = new Overview();

    overview.renderInto(main);

    //main.html(overview.render());
    //overview.bind();
  });
});
