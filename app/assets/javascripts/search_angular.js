angular.module('SearchRoute', [])
.controller('SearchCtrl',['$scope', 'requesterHttp', "$compile",function($scope, requesterHttp, $compile){
  function init(){

    // empty for now

  }

  $scope.searchForAB = function(){

    var input1 = angular.element(document.querySelector("#point_a")).val();
    var input2 = angular.element(document.querySelector("#point_b")).val();

    requesterHttp.getRoute(input1,input2).then(function(data){

      $scope.currentTravelData = data

      var resultDiv = angular.element(document.querySelector("#result_div"))
      resultDiv.html("")
      var nnelement = angular.element(document.createElement("travel-list"));

       var el = $compile(nnelement)($scope);
       resultDiv.append(el);

    })

  }

  init();
}])
.service('requesterHttp',["$http",function($http, $q){

  this.getRoute = function(point_a, point_b){

    var request = $http({
      method: "get",
      url: "/search/"+point_a+"/"+point_b
    })
    return request.then(function(data){
      return data.data;
    }, function(error){
      console.log(error);
    })
  }
}]).directive("travelList", ["$compile",function( $compile){

  return {
    restrict: "AE",
    replace:true,
    scope: false,
    template: "<table id='travelList'> "+
       " <thead><tr><th>Kind of travel</th><th> Duration</th><th>Price</th></tr>  </thead>"+
       "<tbody id='table-body'>  </body>  </table>",

    scope: false,

    link: function(scope, elem, attrs){
      var transports = scope.currentTravelData.transports;
      for (var key in transports) {
        if (transports.hasOwnProperty(key)) {
          $(elem).find("#table-body").append("<tr>"+
                                                  "<td>"+key+"</td>"+
                                                  "<td>"+parseInt(transports[key].duration/60)+":"+transports[key].duration%60+"</td>"
                                                  +"<td>"+transports[key].price+"</td></tr>")

        }
      }

    }
  }
}])
