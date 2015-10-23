gulp = require 'gulp'
mocha = require 'gulp-mocha'

gulp.task 'default', ->
    gulp.start 'test'
    gulp.watch '**/*.coffee', ['test']

gulp.task 'test', ->
    gulp.src 'test.coffee', {read: false}
        .pipe(mocha())


