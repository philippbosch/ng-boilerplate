"use strict"

angular
    .module('boilerplate.controllers.home', [])

    .controller('HomeController', ['$scope', 'time', ($scope, time) ->
        $scope.time = time
    ])
