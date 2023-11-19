extends Control

func update_hp_bar(HP: Dictionary):
	$HPBar.value = (100 / HP['max']) * HP['current']
	
func update_gold(gold: int):
	$GoldText.text = 'GOLD: ' + str(gold)
