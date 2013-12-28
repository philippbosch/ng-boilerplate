"use strict"

angular
    .module('boilerplate', [
        'ui.router',
        'boilerplate.controllers',
        'boilerplate.services'
    ])

    .config(['$stateProvider', '$urlRouterProvider', '$locationProvider', ($stateProvider, $urlRouterProvider, $locationProvider) ->
        $urlRouterProvider.otherwise('/')
        $locationProvider.html5Mode(true)

        $stateProvider.state 'home',
            url: '/'
            views:
                main:
                    templateUrl: 'partials/home.html'
                    controller: 'HomeController'
    ])


angular
    .module('boilerplate.controllers', [
        'boilerplate.controllers.main',
        'boilerplate.controllers.home',
    ])


angular
    .module('boilerplate.services', [
        'boilerplate.services.time',
    ])
