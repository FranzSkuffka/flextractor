gulp = require 'gulp'
shell = require 'gulp-shell'

gulp.task 'default', ->
    gulp.start 'test'
    gulp.watch '**/*.coffee', ['test']

gulp.task 'test', ->
    gulp.src ''
        .pipe shell 'npm test'
