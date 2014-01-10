module.exports = (grunt) ->
    grunt.loadNpmTasks 'grunt-bower-install'
    grunt.loadNpmTasks 'grunt-bower-concat'
    grunt.loadNpmTasks 'grunt-concurrent'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-connect'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-compass'
    grunt.loadNpmTasks 'grunt-contrib-compress'
    grunt.loadNpmTasks 'grunt-contrib-cssmin'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-shell'
    grunt.loadNpmTasks 'grunt-targethtml'

    grunt.registerTask 'dist', ['clean', 'bower_concat', 'coffee', 'compass:dist', 'cssmin', 'concat', 'uglify', 'copy', 'targethtml']
    grunt.registerTask 'deploy', ['dist', 'shell:deployToDokku', 'clean']
    grunt.registerTask 'distserver', ['dist', 'connect:dist']
    grunt.registerTask 'devserver', ['bower-install', 'coffee:dev', 'compass:dev', 'concurrent:dev']

    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'


        'bower_concat':
            all:
                dest: 'build/javascripts/components.js'

        'bower-install':
            target:
                src: ['public/index.html']
                ignorePath: 'public'
                cwd: 'public'

        'clean':
            ['dist', 'build']

        'coffee':
            dev:
                expand: true
                src: 'javascripts/**/*.coffee'
                dest: 'public'
                ext: '.js'

            compile:
                files:
                    'build/javascripts/app.js': ['javascripts/**/*.coffee']

        'compass':
            options:
                httpPath: '/'
                httpStylesheetsPath: '/stylesheets/'
                httpImagesPath: '/images/'
                httpFontsPath: '/fonts/'
                httpJavascriptsPath: '/javascripts/'
                sassDir: 'stylesheets'
                outputStyle: 'expanded'
                relativeAssets: true
                lineComments: false

            dist:
                options:
                    cssDir: 'build/stylesheets'
                    imagesDir: 'build/images'
                    fontsDir: 'build/fonts'
                    javascriptsDir: 'build/javascripts'

            dev:
                options:
                    cssDir: 'public/stylesheets'
                    imagesDir: 'public/images'
                    fontsDir: 'public/fonts'
                    javascriptsDir: 'public/javascripts'

        'concat':
            dist:
                files:
                    'build/javascripts/combined.js': [
                        'build/javascripts/components.js',
                        'build/javascripts/app.js'
                    ]

        'concurrent':
            options:
                logConcurrentOutput: true
            dev:
                tasks: ['watch:compass', 'watch:coffee', 'watch:livereload', 'connect:dev']

        'connect':
            options:
                keepalive: true
                open: false
                hostname: 'localhost'

            dev:
                options:
                    port: 4000
                    base: 'public'
                    debug: true
                    livereload: true
                    middleware: (connect, options) ->
                        [
                            require('connect-file-exists-or-rewrite')(options.base),
                            connect.static(options.base)
                        ]

            dist:
                options:
                    port: 8000
                    base: 'dist'

        'copy':
            dist:
                files: [
                    {cwd: 'public/partials/', expand: true, src: '**', dest: 'dist/partials/'}
                    {cwd: 'public/fonts/', expand: true, src: '**', dest: 'dist/fonts/'}
                    {cwd: 'public/images/', expand: true, src: '**', dest: 'dist/images/'}
                    {cwd: 'public/data/', expand: true, src: '**', dest: 'dist/data/'}
                ]

        'cssmin':
            dist:
                files:
                    'dist/stylesheets/screen.min.css': [
                        'build/stylesheets/screen.css'
                    ]

        'shell':
            initDokkuDeploy:
                options:
                    stdout: true
                    stderr: true
                command: [
                    '[ -d .dokku ] || git clone . .dokku',
                    'cd .dokku',
                    'git show-ref --verify --quiet refs/heads/dist || ( git checkout --orphan dist && git rm -rf . && touch .nginx && mkdir www && touch www/index.html && git add . && git commit -am "Initial commit." )',
                    'git remote add dokku dokku@pbsit.es:<%= pkg.name %>',
                    'git remote add localdokku dokku@dokku.me:<%= pkg.name %>',
                    'git checkout dist',
                    'cd ..'
                ].join(' && ')

            deployToDokku:
                options:
                    stdout: true
                    stderr: true
                command: [
                    '[ -d .dokku ] || ( echo Run "initDokkuDeploy" task first && exit 99)',
                    'rm -rf .dokku/www/*',
                    'cp -R dist/* .dokku/www/',
                    '[ ! -f conf/nginx.conf.erb ] || cp conf/nginx.conf.erb .dokku/',
                    '[ ! -f conf/mime.types ] || cp conf/mime.types .dokku/',
                    'cd .dokku',
                    'date > .deploytime',
                    'git add --all .',
                    'git commit -am "Deploy."',
                    'git push dokku dist:master',
                    'cd ..',
                    'echo Deployed.'
                ].join(' && ')


        'targethtml':
            dist:
                files:
                    'dist/index.html': ['public/index.html']

        'uglify':
            dist:
                files:
                    'dist/javascripts/app.min.js': 'build/javascripts/combined.js'

        'watch':
            options:
                spawn: false

            coffee:
                files: ['javascripts/**/*.coffee']
                tasks: ['coffee:dev']

            compass:
                files: ['stylesheets/**/*.scss']
                tasks: ['compass:dev']

            livereload:
                options:
                    livereload: true
                files: ['public/**/*']
