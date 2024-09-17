extends Terrain
class_name Table

func get_items():
	return $Interaction.get_overlapping_bodies()
