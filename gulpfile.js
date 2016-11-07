"use strict";

const   gulp
            = require('gulp'),
        elm
            = require('gulp-elm'),
        concatCss
            = require('gulp-concat-css'),
        nodemon
            = require('gulp-nodemon');

gulp.task('elm-init', elm.init);

gulp.task('elm-compile', ['elm-init'], function(){
  return gulp.src('client/src/elm/*.elm')
    .pipe(elm.bundle('bundle.js'), {"yesToAllPrompts": true, "elmMake": true})
    .pipe(gulp.dest('client/public/'));
});

gulp.task('html', function() {
    return gulp.src('client/src/**/*.html')
    .pipe(gulp.dest('client/public/'));
});

gulp.task('css', function() {
    return gulp.src('client/src/styles/**/*.css')
    .pipe(concatCss("styles.css"))
    .pipe(gulp.dest('client/public/'));
});

gulp.task('compile', ['elm-init', 'elm-compile', 'css', 'html']);

gulp.task('default', ['compile'], function () {
    return nodemon({
        script: 'app/bin/server.js',
        ext: 'js html css elm',
        watch: ['client/src', 'app/bin', 'app/config', 'app/lib'],
        env: { 'NODE_ENV': 'development' },
        tasks: ['compile']
    });
});
