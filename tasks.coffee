gulp   =     require  'gulp'
util   =     require  'gulp-util'
shell  =     require  'gulp-shell'

gulp.task 'develop', ->
    console.log util.env.module
    if !util.env.module?
        gulp.start 'test'
        gulp.watch '**/*.coffee', ['test']
    if util.env.module?
        gulp.start 'testModule'
        gulp.watch '**/*.coffee', ['testModule']

gulp.task 'testModule', ->
    console.log 'Testing ' + util.env.module
    gulp.src ''
        .pipe shell 'mocha test/test.coffee --grep ' + util.env.module

gulp.task 'test', ->
    gulp.src ''
        .pipe shell 'npm test'
