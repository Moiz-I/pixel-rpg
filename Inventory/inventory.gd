extends Resource

class_name Inv

@export var items: Array[InvItem]

signal update_items

func insert_item(item: InvItem):
	for i in range(items.size()):
		if items[i]==null:
			items[i] = item
			break
	update_items.emit()
