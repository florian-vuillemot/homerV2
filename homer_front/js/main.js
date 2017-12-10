var app = angular.module('HomerV2App', ['ngRoute']);

app.config(['$routeProvider', function ($routeProvider) {
    $routeProvider
    // Home
        .when('/auth/log', {
            controller: 'logController',
            templateUrl: '../html/auth/log.html'
        })
        .when('/auth/register', {
            controller: 'registerController',
            templateUrl: '../html/auth/register.html'
        })
        .when('/', {
            controller: 'homeController',
            templateUrl: '../html/home.html'
        })
        .when('/projects/new', {
            controller: 'newProjectController',
            templateUrl: '../html/projects/new.html'
        })
        .when('/projects/finished', {
            controller: 'newProjectController',
            templateUrl: '../html/projects/finished.html'
        })
        .otherwise({
            redirectTo: "/auth/log"
        })
}]);

app.controller('logController', function($scope) {
    $scope.id = "";
    $scope.password = "";
    $scope.connexion = function () {
        console.log("Connexion")
    };
});

app.controller('registerController', function ($scope) {
    $scope.prenom = "";
    $scope.nom = "";
    $scope.email = "";
    $scope.password = "";
    $scope.validatePassword = "";
    $scope.createAccount = function () {
        console.log("Compte crée");
        console.log($scope.prenom);
        console.log($scope.nom);
        console.log($scope.email);
        if ($scope.password != $scope.validatePassword){
            console.log("Mot de passe différent");
        }
    }
});

app.controller('homeController', function ($scope) {

});

app.controller('newProjectController', function($scope){
    $scope.name = "";
    $scope.spices = "";
    $scope.github = "";
    $scope.datefu1 = "";
    $scope.fu1 = "";
    $scope.datefu2 = "";
    $scope.fu2 = "";
    $scope.dateDelivery = "";
    $scope.delivery = "";
    $scope.sendProject = function () {
        console.log("Projet soumis à validation");
        console.log("Nom du Projet = ", $scope.name);
        console.log("Epices demandées = ", $scope.spices);
        console.log("Github = ", $scope.github);
        console.log("Date follow up 1 = ", $scope.datefu1);
        console.log("Follow up 1 = ", $scope.fu1);
        console.log("Date follow up 2 = ", $scope.datefu2);
        console.log("Follow up 2 = ", $scope.fu2);
        console.log("Date Delivery = ", $scope.dateDelivery);
        console.log("Delivery = ", $scope.delivery);
    }
});