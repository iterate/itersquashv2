"use strict";

const   gulp
            = require('gulp'),
        concatCss
            = require('gulp-concat-css'),
        nodemon
            = require('gulp-nodemon'),
        gutil
            = require('gulp-util'),
        spawn
            = require("child_process").spawn;

gulp.task('elm-compile', function(done){
      let child = spawn("elm-make", ["--output", "client/public/bundle.js", "client/src/elm/Main.elm"], {cwd: process.cwd()}),
          stdout = '',
          stderr = '';

      child.stdout.setEncoding('utf8');
      child.stderr.setEncoding('utf8');

      child.stdout.on('data', function (data) {
          stdout += data;
          gutil.log(data);
      });

      child.stderr.on('data', function (data) {
          stderr += data;
          gutil.log(gutil.colors.red(data));
          gutil.beep();
      });

      child.on('close', function(code) {
          gutil.log("Done with exit code", code);
           done();
      });

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

gulp.task('default', ['elm-compile','css', 'html'], function () {
    return nodemon({
        script: 'app/bin/server.js',
        ext: 'js html css elm',
        watch: ['client/src', 'app/bin', 'app/config', 'app/lib'],
        env: { 'NODE_ENV': 'development' },
        tasks: ['compile']
    });
});
