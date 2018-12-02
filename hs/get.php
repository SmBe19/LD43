<?php
if (!file_exists("highscore.txt")){
  file_put_contents("highscore.txt", "[]");
}
$high = file_get_contents("highscore.txt");
$highjs = json_decode($high);
while(count($highjs) > 100){
  unset($highjs[100]);
}
if (isset($_GET['format'])){
  if ($_GET['format'] == "lua") {
    for($i = 0; $i < count($highjs); $i++){
      echo $highjs[$i]->name;
      echo "\n";
      echo $highjs[$i]->score;
      echo "\n";
    }
  } else {
    echo $high;
    echo "\n";
  }
} else {
  echo $high;
  echo "\n";
}
?>
