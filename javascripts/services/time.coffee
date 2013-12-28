"use strict"

angular
    .module('boilerplate.services.time', [])

    .factory('time', ->
        new Date()
    )
