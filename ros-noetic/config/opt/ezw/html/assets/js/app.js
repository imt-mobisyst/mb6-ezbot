// ####################### Debug ########################

// CPU (function(){var script=document.createElement('script');script.onload=function(){var stats=new Stats();stats.showPanel( 0 );document.body.appendChild(stats.dom);requestAnimationFrame(function loop(){stats.update();requestAnimationFrame(loop)});};script.src='//mrdoob.github.io/stats.js/build/stats.min.js';document.head.appendChild(script);})()
// MEM (function () { var script = document.createElement('script'); script.onload = function () { var stats = new Stats(); stats.showPanel(2); document.body.appendChild(stats.dom); requestAnimationFrame(function loop() { stats.update(); requestAnimationFrame(loop) }); }; script.src = '//mrdoob.github.io/stats.js/build/stats.min.js'; document.head.appendChild(script); })()

// ####################### Commons ########################

showSpinningLoader(true);

window.onload = function () {
  console.log("Onload");
  if ($(document).height() > $(window).height()) {
    var scrollTop = $("html").scrollTop()
      ? $("html").scrollTop()
      : $("body").scrollTop(); // Works for Chrome, Firefox, IE...
    $("html").addClass("noscroll").css("top", -scrollTop);
  }
};

// ################### Connecting to ROS ###################

var url = window.location.href;
var arr = url.split("/");
var host = arr[2];

var rosbridge_url = "ws://" + host + ":9090";

var ros = new ROSLIB.Ros({
  url: rosbridge_url,
});

ros.on("connection", function () {
  document.getElementById("cas-active").classList.remove("red-light");
  document.getElementById("cas-active").classList.add("green-light");
  console.log("Connected to websocket server.");
});

ros.on("error", function (error) {
  document.getElementById("cas-active").classList.remove("green");
  document.getElementById("cas-active").classList.add("red-light");
  console.log("Error connecting to websocket server: ", error);
  showSpinningLoader(true);
});

ros.on("close", function () {
  document.getElementById("cas-active").classList.remove("green");
  document.getElementById("cas-active").classList.add("red-light");
  console.log("Connection to websocket server closed.");
  showSpinningLoader(true);
});

// Handle ROS connection
window.setInterval(function () {
  if (ros.isConnected) return;
  console.log(ros.isConnected);

  var img = document.getElementById("safety_img");

  img.src = "assets/img/NONE_fonctions-securitaire.png";

  document.getElementById("sdi-active").classList.remove("red");
  document.getElementById("sdi-active").classList.add("OFF");

  document.getElementById("sls-active").classList.remove("red");
  document.getElementById("sls-active").classList.add("OFF");

  document.getElementById("sto-active").classList.remove("red");
  document.getElementById("sto-active").classList.add("OFF");

  ros.connect(rosbridge_url);
}, 1000);

// ##################### Viewer #####################

// Create the main viewer.
var viewer = new ROS3D.Viewer({
  divID: "map",
  width: 800,
  height: 600,
  background: "#5D6E6C",
  antialias: true,
  cameraPose: {
    x: 10,
    y: 10,
    z: 10,
  },
});

// Setup the grid client.
var gridClient = new ROS3D.OccupancyGridClient({
  ros: ros,
  rootObject: viewer.scene,
  continuous: true,
  // color: {
  //   r:125,g:125,b:200,a:255
  // }
  // 93 110 108
});

var grid = new ROS3D.Grid({
  color: 0x8f9396,
  num_cells: 100,
  lineWidth: 1,
  cellSize: 1,
});

viewer.addObject(grid);

// Setup a client to listen to TFs.
var tfClient = new ROSLIB.TFClient({
  ros: ros,
  angularThres: 0.01,
  transThres: 0.01,
  rate: 10.0,
  fixedFrame: "/map",
});

var laser = new ROS3D.LaserScan({
  ros: ros,
  tfClient: tfClient,
  rootObject: viewer.scene,
  topic: "/laser_1/scan",
  material: { size: 0.1, color: 0x37f9f9 },
});

var pose = new ROS3D.Pose({
  ros: ros,
  tfClient: tfClient,
  rootObject: viewer.scene,
  topic: "/slam_out_pose",
  color: 0xff2100,
});

var path = new ROS3D.Path({
  ros: ros,
  tfClient: tfClient,
  rootObject: viewer.scene,
  topic: "/path_pose",
  color: 0xff0000,
});

// ##################### tools functions #####################

const radians_to_degrees = (rad) => (rad * 180.0) / Math.PI;

function showSpinningLoader(visible) {
  var x = document.getElementById("spinning-loader");
  if (visible) {
    x.style.display = "block";
  } else {
    x.style.display = "none";
  }
}

// ##################### Handling taps #####################

var clear_map_btn = document.getElementById("clear_map_btn");

clear_map_btn.addEventListener("mouseup", clear_map_onclick, false);
clear_map_btn.addEventListener("touchend", clear_map_onclick, false);

var reboot_btn = document.getElementById("reboot_btn");

reboot_btn.addEventListener("mouseup", reboot_onclick, false);
reboot_btn.addEventListener("touchend", reboot_onclick, false);

var shutdown_btn = document.getElementById("shutdown_btn");

shutdown_btn.addEventListener("mouseup", shutdown_onclick, false);
shutdown_btn.addEventListener("touchend", shutdown_onclick, false);

// ##################### syscommand topics #####################

var syscommand_topic = new ROSLIB.Topic({
  ros: ros,
  name: "/syscommand",
  messageType: "std_msgs/String",
  queue_size: 1,
});

var robot_manager_command_topic = new ROSLIB.Topic({
  ros: ros,
  name: "/robot_command",
  messageType: "std_msgs/String",
  queue_size: 1,
});

function pub_syscommand(str) {
  var msg = new ROSLIB.Message({
    data: str,
  });
  syscommand_topic.publish(msg);
}

function pub_robot_manager_command(str) {
  var msg = new ROSLIB.Message({
    data: str,
  });
  robot_manager_command_topic.publish(msg);
}

function clear_map_onclick() {
  console.log("clear_map_onclick");

  pub_syscommand("reset");
}

function reboot_onclick() {
  console.log("reboot_onclick");

  pub_robot_manager_command("reboot");

  showSpinningLoader(true);

  setTimeout(function () {
    location.reload(true);
  }, 30000);
}

function shutdown_onclick() {
  console.log("shutdown_onclick");

  pub_robot_manager_command("shutdown");

  showSpinningLoader(true);

  location.reload(true);
}

// yaw (z-axis rotation)
function get_yaw(orientation) {
  qx = orientation.x;
  qy = orientation.y;
  qz = orientation.z;
  qw = orientation.w;
  siny_cosp = 2 * (qw * qz + qx * qy);
  cosy_cosp = 1 - 2 * (qy * qy + qz * qz);
  yaw = Math.atan2(siny_cosp, cosy_cosp);

  return yaw;
}

// ##################### slam topics #####################

var slam_out_pose_topic = new ROSLIB.Topic({
  ros: ros,
  name: "/slam_out_pose",
  messageType: "geometry_msgs/PoseStamped",
  queue_size: 1,
});

var odom_topic = new ROSLIB.Topic({
  ros: ros,
  name: "/swd_diff_drive_controller/odom",
  messageType: "nav_msgs/Odometry",
  queue_size: 1,
});

var yaw = 0;
var vel = 0;
var simulate_safety_functions = false;

slam_out_pose_topic.subscribe(function (message) {
  showSpinningLoader(false);

  yaw = get_yaw(message.pose.orientation);
});

odom_topic.subscribe(function (message) {
  showSpinningLoader(false);

  vel = message.twist.twist.linear.x;
});

// Update yaw in GUI
window.setInterval(function () {
  document.getElementById("yaw").innerHTML = radians_to_degrees(yaw).toFixed(2);
}, 500);

// Update velocity in GUI
window.setInterval(function () {
  document.getElementById("vel").innerHTML = vel.toFixed(2);
}, 500);

// ##################### Safety #####################
var safety_functions_topic = new ROSLIB.Topic({
  ros: ros,
  name: "/swd_diff_drive_controller/safety",
  messageType: "swd_ros_controllers/SafetyFunctions",
  queue_size: 1,
});

safety_functions_topic.subscribe(function (message) {
  var img = document.getElementById("safety_img");
  sto = "";
  if (message.safe_torque_off) {
    sto = "-AU";
  }

  if (message.safe_direction_indication_forward) {
    img.src = "assets/img/SDI_fonctions-securitaire" + sto + ".png";
  } else if (message.safety_limited_speed_1 || message.safety_limited_speed_2) {
    img.src = "assets/img/SLS_fonctions-securitaire" + sto + ".png";
  } else {
    img.src = "assets/img/NONE_fonctions-securitaire" + sto + ".png";
  }

  if (message.safe_torque_off) {
    document.getElementById("sto-active").classList.remove("OFF");
    document.getElementById("sto-active").classList.add("red");
  } else {
    document.getElementById("sto-active").classList.remove("red");
    document.getElementById("sto-active").classList.add("OFF");
  }

  if (message.safe_direction_indication_forward) {
    document.getElementById("sdi-active").classList.remove("OFF");
    document.getElementById("sdi-active").classList.add("red");
  } else {
    document.getElementById("sdi-active").classList.remove("red");
    document.getElementById("sdi-active").classList.add("OFF");
  }

  if (message.safety_limited_speed_1 || message.safety_limited_speed_2) {
    document.getElementById("sls-active").classList.remove("OFF");
    document.getElementById("sls-active").classList.add("red");
  } else {
    document.getElementById("sls-active").classList.remove("red");
    document.getElementById("sls-active").classList.add("OFF");
  }
});
