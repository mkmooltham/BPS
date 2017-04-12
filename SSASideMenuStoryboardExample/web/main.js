var map = null;
var markerIcon = null;
var marker = null;

var graph = directed_graph;

var polyLine = null;
var movingMarker = null;

var previousPoint = null;
var currentPoint = null;

$(document).ready(function(){
    // init marker icon
    markerIcon = L.icon({
        iconUrl: 'img/location_indicator.png',
        // no need shadow
        //shadowUrl: 'leaf-shadow.png',

        iconSize:     [48, 48], // size of the icon
        //shadowSize:   [50, 64], // size of the shadow
        iconAnchor:   [24, 24] // point of the icon which will correspond to marker's location
    });

	// init the map
	map = L.map('mapid', {
		crs: L.CRS.Simple
	});

	var bounds = [[0,0], [800,600]]; // [height, width]
	// add image to map
	var image = L.imageOverlay('img/floor_plan.png', bounds).addTo(map);
	map.fitBounds(bounds);

	// set marker
	//marker = L.marker([371, 178], {icon: markerIcon});
  //marker.addTo(map).bindPopup('You are around here!'); // y, x in pixel

	/*var driver = L.latLng([ 378, 178 ]); // y, x
	marker = L.marker(driver);
	marker.addTo(map).bindPopup('driver');*/

	// center the view according to the marker
	// map.setView( [210, 110], 1);


  /*
  Testing
  */
	//test1();
	//test2();
/*
	setTimeout(function(){
		var moving_path_order = graph.findShortestPath('p1', 'p1');
		var linked_moving_points = link(moving_path_order);

		movingMarker = L.Marker
		.movingMarker(
			linked_moving_points.coordinates,
			linked_moving_points.durations,
			{icon: markerIcon}
		).addTo(map);

		movingMarker.start();

		var path_order = graph.findShortestPath('p1', 'p1'); // ['a', 'c', 'b']
		console.log(path_order);
		var linked_points = link(path_order);

		if(polyLine != null){
			 map.removeLayer(polyLine);
		}
		polyLine = L.polyline(linked_points.coordinates, {color: 'yellow'}).addTo(map);
	}, 600);
*/

});

function link(path_order){
  // input: ['p1', 'forkA', 'p2', 'p3', 'c']
  // the number behind 'p' is the bid
  // last item must be car lot id string
  // p2's x, y = deployed_beacons[2].x, deployed_beacons[2].y
  if(path_order != null && path_order.length > 1){
    var yx_arr = [];
		var duration_arr = [];
    for(var i = 0; i < path_order.length; i++){
			if(path_order[i].indexOf('p') == 0 && path_order[i].length > 1){
				var id = parseInt(path_order[i].substring(1)); // p10 => 10
				var beacon_points = deployed_beacons.filter(function(obj){
					return obj.bid == id;
				});
				if(beacon_points.length != 0){
					yx_arr.push([beacon_points[0].y, beacon_points[0].x]);
					duration_arr.push(100);
					console.log("push point: " + beacon_points[0].bid);
				}
			}
			else if(path_order[i].indexOf('fork') != -1){
				var forks = fork_points.filter(function(obj){
					return obj.fork_id == path_order[i];
				});
				if(forks.length != 0){
					yx_arr.push([forks[0].y, forks[0].x]);
					duration_arr.push(100);
					console.log("push fork point: " + forks[0].fork_id);
				}
			}
			else { // case: path_order[i] belongs to car ids
				var lots = car_lots.filter(function(obj){
					return obj.car_id == path_order[i];
				});
				if(lots.length != 0){
					yx_arr.push([lots[0].y, lots[0].x]);
					duration_arr.push(100);
					console.log("push car lot point: " + lots[0].car_id);
				}
			}
    }
		return {
			coordinates: yx_arr,
			durations: duration_arr
		};
  }
	else {
		return {
			coordinates: [],
			durations: []
		};
	}
}

/*
Current location point update
input object array = [
{bid: 1, rssi: -99},
{bid: 2, rssi: -99},
{bid: 3, rssi: 0},
{bid: 4, rssi: 0},
{bid: 5, rssi: -99}
];
*/
function updateMarker(showMyPointOnly, isDirectedGraph, destination, arr){ // arr must be json array string
  var jsonArray = JSON.parse(arr);
  if(jsonArray.length == 0){
    console.log("Empty array");
    return;
  }

  var matchedPoint = findClosestBeaconAsCurrentPoint(jsonArray);
	if(matchedPoint.matched == true){
		previousPoint = currentPoint;
		currentPoint = matchedPoint;
		console.log("Match point, bid: " + currentPoint.bid + ", x: " + currentPoint.x + ", y: " + currentPoint.y);
	}
	else {
		console.log("No Match point found");
		console.log("------------------------------");
		return;
	}

	if(isDirectedGraph){
		graph = directed_graph;
	}
	else {
		graph = undirected_graph;
	}

	// update position with moving marker animation
	// first point received
	if(previousPoint == null && currentPoint != null){
		var path_order = graph.findShortestPath('p' + currentPoint.bid, destination); // ['a', 'c', 'b']
		if(path_order == null){
			currentPoint = previousPoint; // roll back
			console.log("invalid path");
			console.log("------------------------------");
			return;
		}

		// print the path
		removePath();
		if(showMyPointOnly == 0){
			console.log(path_order);
			var linked_points = link(path_order);
			polyLine = L.polyline(linked_points.coordinates, {color: 'yellow'}).addTo(map);
		}

		// print static marker
		removeMaker();
		movingMarker = L.Marker
		.movingMarker(
			[[currentPoint.y, currentPoint.x]],
			[100],
			{icon: markerIcon}
		).addTo(map);
	}
	else if(previousPoint != null && currentPoint != null
		&& previousPoint.bid != currentPoint.bid){
			var path_order = graph.findShortestPath('p' + currentPoint.bid, destination); // ['a', 'c', 'b']
			console.log("path_order: ");
			console.log(path_order);
			var moving_path_order = undirected_graph.findShortestPath('p' + previousPoint.bid, 'p' + currentPoint.bid);
			console.log("moving_path_order: ");
			console.log(moving_path_order);

			if(path_order == null || moving_path_order == null){
				currentPoint = previousPoint; // roll back
				console.log("invalid path");
				console.log("------------------------------");
				return;
			}
			// animate moving point
			var linked_moving_points = link(moving_path_order);

			removeMaker();
			movingMarker = L.Marker
			.movingMarker(
				linked_moving_points.coordinates,
				linked_moving_points.durations,
				{icon: markerIcon}
			).addTo(map);

			movingMarker.start();
			console.log("MovingMarker.start");

			// Update the path
			removePath();
			if(showMyPointOnly == 0){
				var linked_points = link(path_order);
				polyLine = L.polyline(linked_points.coordinates, {color: 'yellow'}).addTo(map);
			}
	}
	else if(previousPoint != null && currentPoint != null
		&& previousPoint.bid == currentPoint.bid){ // at same point
			removePath();
			if(showMyPointOnly == 0){
				var path_order = graph.findShortestPath('p' + currentPoint.bid, destination); // ['a', 'c', 'b']
				console.log("path_order: ");
				console.log(path_order);

				if(path_order == null){
					currentPoint = previousPoint; // roll back
					console.log("invalid path");
					console.log("------------------------------");
					return;
				}

				var linked_points = link(path_order);
				polyLine = L.polyline(linked_points.coordinates, {color: 'yellow'}).addTo(map);
			}
		}
  console.log("------------------------------");
}

function removeMaker(){
	if(movingMarker != null){
		map.removeLayer(movingMarker);
		movingMarker = null;
		console.log("remove previous marker");
	}
}

function removePath(){
	if(polyLine != null){
		 map.removeLayer(polyLine);
		 polyLine = null;
	}
}

/*
received_beacons = [
{bid: 1, rssi: -99},
{bid: 2, rssi: -99},
{bid: 3, rssi: 0},
{bid: 4, rssi: 0},
{bid: 5, rssi: -99}
];
*/
function findClosestBeaconAsCurrentPoint(received_beacons){
  var max_rssi = Number.MIN_SAFE_INTEGER;
  var closestBeacon;
  for(var i = 0; i < received_beacons.length; i++){
    var beacon = received_beacons[i];
    if(beacon.rssi > max_rssi){
      max_rssi = beacon.rssi;
      closestBeacon = beacon;
    }
  }
  console.log("closest Beacon bid: " + closestBeacon.bid + ", rssi: " + closestBeacon.rssi);
  var result = {
    "bid": -1,
    "rssi": 0,
    "x": 0,
    "y": 0,
    "matched": false
  };
  for(var i = 0; i < deployed_beacons.length; i++){
    if(closestBeacon.bid == deployed_beacons[i].bid){
      result.bid = deployed_beacons[i].bid;
      result.rssi = closestBeacon.rssi;
      result.x = deployed_beacons[i].x;
      result.y = deployed_beacons[i].y;

      result.matched = true;
      break;
    }
  }

  return result;
}

// case: directed_graph
function test1(){
	var showMyPointOnly = 1;
	var isDirectedGraph = 1;

	setTimeout(function(){
		var test_data = '[{"bid": 1, "rssi": -55},{"bid": 2, "rssi": -62},{"bid": 4, "rssi": -75},{"bid": 5, "rssi": -80}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p1', test_data);
	}, 0);
	setTimeout(function(){
		var test_data = '[{"bid": 1, "rssi": -55},{"bid": 2, "rssi": -62},{"bid": 4, "rssi": -75},{"bid": 5, "rssi": -80}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p1', test_data);
	}, 150);
	setTimeout(function(){
		var test_data = '[{"bid": 1, "rssi": -55},{"bid": 2, "rssi": -62},{"bid": 4, "rssi": -75},{"bid": 5, "rssi": -80}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p1', test_data);
	}, 300);
	setTimeout(function(){
		var test_data = '[{"bid": 1, "rssi": -55},{"bid": 2, "rssi": -62},{"bid": 4, "rssi": -75},{"bid": 5, "rssi": -80}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p1', test_data);
	}, 350);

	setTimeout(function(){
		var test_data = '[{"bid": 2, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 450);

	setTimeout(function(){
		var test_data = '[{"bid": 200, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 500);

	setTimeout(function(){
		var test_data = '[{"bid": 20, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 600);

	setTimeout(function(){
		var test_data = '[{"bid": 1, "rssi": -55},{"bid": 2, "rssi": -59},{"bid": 4, "rssi": -62},{"bid": 5, "rssi": -80}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 1000);

	setTimeout(function(){
		var test_data = '[{"bid": 1, "rssi": -62},{"bid": 2, "rssi": -59},{"bid": 4, "rssi": -55},{"bid": 5, "rssi": -62}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 1500);

	setTimeout(function(){
		var test_data = '[{"bid": 1, "rssi": -62},{"bid": 2, "rssi": -59},{"bid": 4, "rssi": -65},{"bid": 5, "rssi": -55}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 2000);

	setTimeout(function(){
		var test_data = '[{"bid": 1, "rssi": -62},{"bid": 2, "rssi": -59},{"bid": 4, "rssi": -65},{"bid": 5, "rssi": -55}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 2500);

	setTimeout(function(){
		var test_data = '[{"bid": 1, "rssi": -62},{"bid": 2, "rssi": -59},{"bid": 4, "rssi": -65},{"bid": 5, "rssi": -55}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 3000);

	setTimeout(function(){
		var test_data = '[{"bid": 22, "rssi": -55}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 3100);

	setTimeout(function(){
		var test_data = '[{"bid": 11, "rssi": -55}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 3400);

	setTimeout(function(){
		var test_data = '[{"bid": 9, "rssi": -55}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 3800);

	setTimeout(function(){
		var test_data = '[{"bid": 55, "rssi": -55}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 4100);

	setTimeout(function(){
		var test_data = '[{"bid": 55, "rssi": -55}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 4200);
}

// Test case: undirected_graph
function test2(){
	var showMyPointOnly = 0;
	var isDirectedGraph = 0;

	setTimeout(function(){
		var test_data = '[{"bid": 22, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 0);
	setTimeout(function(){
		var test_data = '[{"bid": 22, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 50);
	setTimeout(function(){
		var test_data = '[{"bid": 22, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 100);
	setTimeout(function(){
		var test_data = '[{"bid": 21, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 300);
	setTimeout(function(){
		var test_data = '[{"bid": 21, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 500);
	setTimeout(function(){
		var test_data = '[{"bid": 21, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 700);
	setTimeout(function(){
		var test_data = '[{"bid": 19, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 1000);
	setTimeout(function(){
		var test_data = '[{"bid": 19, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 1200);
	setTimeout(function(){
		var test_data = '[{"bid": 18, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 1500);
	setTimeout(function(){
		var test_data = '[{"bid": 17, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 1800);
	setTimeout(function(){
		var test_data = '[{"bid": 6, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 2100);
	setTimeout(function(){
		var test_data = '[{"bid": 7, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 2400);
	setTimeout(function(){
		var test_data = '[{"bid": 16, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 2700);
	setTimeout(function(){
		var test_data = '[{"bid": 15, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 3900);
	setTimeout(function(){
		var test_data = '[{"bid": 14, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 3300);
	setTimeout(function(){
		var test_data = '[{"bid": 13, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 3600);
	setTimeout(function(){
		var test_data = '[{"bid": 12, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 3900);
	setTimeout(function(){
		var test_data = '[{"bid": 11, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 4100);
	setTimeout(function(){
		var test_data = '[{"bid": 55, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 4400);
	setTimeout(function(){
		var test_data = '[{"bid": 55, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 4700);
	setTimeout(function(){
		var test_data = '[{"bid": 55, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 5000);
	setTimeout(function(){
		var test_data = '[{"bid": 13, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 5300);
	setTimeout(function(){
		var test_data = '[{"bid": 11, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 5700);
	setTimeout(function(){
		var test_data = '[{"bid": 55, "rssi": -59}]';
		updateMarker(showMyPointOnly, isDirectedGraph, 'p55', test_data);
	}, 6100);
}
