<?

if (!function_exists("dir")) {
  $_SERVER['PHP_ROOT'] = '/home/drh/www';

  include $_SERVER['PHP_ROOT'].'/flib/__flib.php';
  flib_init(FLIB_CONTEXT_TEST);
  require_module('entity/utils');
  $me = 656681242;
  $vc = vc($me);
  $ent = ent($me);

  $london = array(51.5359854981554, -0.03354907035827637);
  $mountain_view = array(37.3860517, -122.0838511);

  function load($module) { // convenient
        require_module($module);
  }

  function dir($class) {
    print get_class($class);
    if(get_parent_class($class)) print " : " . get_parent_class($class);
    print "\n";

    $methods = get_class_methods($class);
    foreach($methods as $method) {
        print "::" . $method . "\n";
    }
  }
}
