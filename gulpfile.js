var gulp = require('gulp');
var webpack = require('webpack-stream');

gulp.task('copy-src', function() {
    gulp.src('src/**')
        .pipe(gulp.dest('dist/'));
});

gulp.task('default', ['copy-src'], function() {

});

gulp.task('update-libs', function() {
  var map = [
    ['src/lib/jquery', ['node_modules/jquery/dist/jquery?(.min).@(js|map)']],
    ['src/lib/moment', ['node_modules/moment/moment*.js', 'node_modules/moment/min/moment*.js']],
    ['src/lib/mustache', ['node_modules/mustache/mustache*.js']],
    ['src/lib/requirejs', ['node_modules/requirejs/require.js', 'node_modules/requirejs-text/text.js']],
    ['src/lib/react', ['node_modules/react/dist/*.js', 'node_modules/react-dom/dist/*.js']]
  ];

  for(var mapping of map) {
    var dst = mapping[0];
    var srcs = mapping[1];

    gulp.src(srcs)
        .pipe(gulp.dest(dst));
  }
});
