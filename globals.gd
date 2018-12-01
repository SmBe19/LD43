extends Node

enum ORGANS {BRAIN=0, HEART=1, LUNGS=2, LIVER=3, LKIDNEY=4, RKIDNEY=5}

var organ_drag_drop_enabled = true

var death_speed = 1
var death_speed_acc = 0.001