define(['lib/react/react', 'components/overview/js?'],
  function(react, Overview) {

  $(function() {
    var main = $("#main");
    var overview = new Overview();

    overview.renderInto(main);

    //main.html(overview.render());
    //overview.bind();
  });
});
