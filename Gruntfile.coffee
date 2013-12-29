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
    grunt.loadNpmTasks 'grunt-rsync'
    grunt.loadNpmTasks 'grunt-targethtml'

    grunt.registerTask 'default', ['clean', 'bower_concat', 'coffee', 'concat', 'uglify', 'compass', 'cssmin', 'targethtml', 'copy']
    grunt.registerTask 'deploy', ['default', 'rsync', 'clean']
    grunt.registerTask 'distserver', ['default', 'connect:dist']
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
                imagesDir: 'public/images'
                fontsDir: 'public/fonts'
                javascriptsDir: 'public/javascripts'
                outputStyle: 'expanded'
                relativeAssets: true
                lineComments: false

            dist:
                options:
                    cssDir: 'build/stylesheets'

            dev:
                options:
                    cssDir: 'public/stylesheets'

        'concat':
            dist:
                files:
                    'build/javascripts/combined.js': [
                        'build/javascripts/components.js',
                        'public/components/codemirror/mode/markdown/markdown.js',
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
                    middleware: (connect, options) ->
                        [
                            require('connect-livereload')(),
                            connect.static(options.base),
                        ]

            dist:
                options:
                    port: 8888
                    base: 'dist'

        'copy':
            dist:
                files: [
                    {cwd: 'public/partials/', expand: true, src: '**', dest: 'dist/partials/'}
                ]

        'cssmin':
            dist:
                files:
                    'dist/stylesheets/screen.min.css': [
                        'build/stylesheets/screen.css'
                    ]

        'rsync':
            dist:
                options:
                    src: './dist/'
                    dest: 'public_html'
                    host: 'user@host'
                    recursive: true

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
