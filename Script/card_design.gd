extends CanvasGroup

@export var elixer_texture : CompressedTexture2D

func update_visuals(card : piece):
	if card.damage <= 0:
		%damage_label.visible = false
		%sword.visible = false
		
	else:
		%damage_label.visible = true
		%sword.visible = true
	%health_label.text = "[b]" + str(card.health)
	%card_label.text = "[center]" + card.name
	%damage_label.text = "[b]" + str(card.damage)
	%Skill.texture = card.skill_texture
	var player_id = multiplayer.get_unique_id()
	if player_id == 1:
		$%pawn_texture.texture_normal = card.player_pawn_texture
	else: $%pawn_texture.texture_normal = card.opponent_pawn_texture
	
	for elixer in %elixer.get_children(): #Clear first before getting replaced
		elixer.queue_free()
	for elixer in range(card.elixer): #elixer/power needed for this card
		var textureRect = TextureRect.new()
		textureRect.texture = elixer_texture
		%elixer.add_child(textureRect)
