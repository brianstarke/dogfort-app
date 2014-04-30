gulp    = require 'gulp'
jade    = require 'gulp-jade'
clean   = require 'gulp-clean'
coffee  = require 'gulp-coffee'
less    = require 'gulp-less'
concat  = require 'gulp-concat'
uglify  = require 'gulp-uglify'

paths =
  jade: ['**/*.jade', '!node_modules/**/*.jade']
  coffee: ['scripts/**/*.coffee']
  scripts: [
    './components/jquery/jquery.min.js'
    './components/uikit/dist/js/uikit.min.js'
    './components/uikit/dist/js/addons/sticky.min.js'
    './components/angular/angular.min.js'
    './components/angular-route/angular-route.min.js'
    './components/angular-cookies/angular-cookies.min.js'
    './components/angular-resource/angular-resource.min.js'
    './components/angular-toastr/dist/angular-toastr.min.js'
    './components/moment/min/moment.min.js'
    './components/angular-moment/angular-moment.min.js'
    './components/angularjs-scroll-glue/src/scrollglue.js'
  ]
  less: './less/**/*.less'
  fonts: ['./components/uikit/src/fonts/*.*']
  images: './images/{*.ico,*.jpg,*.png}'
  dist: './dist'

# clean public folder
gulp.task 'clean', ->
  gulp.src(paths.dist, {read: false})
    .pipe clean({force: true})

# compile jade templates
gulp.task 'jade', ->
  gulp.src(paths.jade)
    .pipe(jade())
    .pipe(gulp.dest(paths.dist))

# compile less styles
gulp.task 'less', ->
  gulp.src(paths.less)
    .pipe(less())
    .pipe(gulp.dest(paths.dist + '/styles'))

# compile/concat coffeescript
gulp.task 'coffee', ->
  gulp.src(paths.coffee)
    .pipe(coffee())
    .pipe(concat('dogfort.js'))
    .pipe(gulp.dest(paths.dist + '/scripts'))

gulp.task 'scripts', ->
  gulp.src(paths.scripts)
    .pipe(uglify())
    .pipe(concat('thirdparty.min.js'))
    .pipe(gulp.dest(paths.dist + '/scripts'))

# copy fonts
gulp.task 'fonts', ->
  gulp.src(paths.fonts)
    .pipe gulp.dest(paths.dist + '/fonts')

# copy images
gulp.task 'images', ->
  gulp.src(paths.images)
    .pipe gulp.dest(paths.dist + '/images')

# rerun the task when a file changes
gulp.task 'watch', ->
  gulp.watch paths.coffee, ['coffee']
  gulp.watch paths.jade, ['jade']
  gulp.watch paths.less, ['less']
  gulp.watch paths.fonts, ['fonts']

# do ALL THE THINGS
gulp.task 'build', [
  'less'
  'jade'
  'fonts'
  'scripts'
  'images'
  'coffee'
]

gulp.task 'default', [
  'less'
  'jade'
  'fonts'
  'scripts'
  'images'
  'coffee'
  'watch'
]
