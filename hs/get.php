<?php
if (!file_exists("highscore.txt")){
  file_put_contents("highscore.txt", "[]");
}
$high = file_get_contents("highscore.txt");
$highjs = json_decode($high);
$limit = 10;
if (isset($_GET['limit']) && is_numeric($_GET['limit'])) {
  $limit = intval($_GET['limit']);
}
$highjs = array_slice($highjs, 0, $limit);
if (isset($_GET['format'])){
  if ($_GET['format'] == "lua") {
    for($i = 0; $i < count($highjs); $i++){
      echo $highjs[$i]->name;
      echo "\n";
      echo $highjs[$i]->score;
      echo "\n";
    }
  } else {
    echo json_encode($highjs);
    echo "\n";
  }
} else {
  echo json_encode($highjs);
  echo "\n";
}
?>
