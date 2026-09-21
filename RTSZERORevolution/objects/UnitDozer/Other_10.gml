switch(EVENT[0]) {
	case EventType.NetWrite:
		var Buff = EVENT[1];
		
		buffer_write(Buff, buffer_u16, round(ToX * 10));
		buffer_write(Buff, buffer_u16, round(ToY * 10));
		buffer_write(Buff, buffer_u16, instance_exists(Target) ? Target.NetUID : 0);
	break;
	
	case EventType.NetRead:
		var Buff = EVENT[1];
		
		ToX = buffer_read(Buff, buffer_u16) / 10;
		ToY = buffer_read(Buff, buffer_u16) / 10;
		var npTarget = buffer_read(Buff, buffer_u16);
		Target = npTarget ? net_search_uid(npTarget) : noone;
	break;
	
	case EventType.CivAbilityStartBuild:
		var AbilityID = Abilities[EVENT[1]];
		var XX = EVENT[2] * 16, YY = EVENT[3] * 16, D = EVENT[4];
		// Область постройки соответствует размеру спрайта здания
		var BuildSpr = Game.AbilitiesData[AbilityID];
		var x1 = XX - sprite_get_xoffset(BuildSpr), y1 = YY - sprite_get_yoffset(BuildSpr);
		var x2 = x1 + sprite_get_width(BuildSpr) - 1, y2 = y1 + sprite_get_height(BuildSpr) - 1;
		
		var CanBuild = (Plr.Cash >= Game.AbilitiesPrice[AbilityID] and 
			!collision_rectangle(x1, y1, x2, y2, Builds, false, false) and
			!collision_rectangle(x1, y1, x2, y2, Terrains, false, false));
		
		// Для добытчика перидота — рядом должен быть нейтральный склад
		if(CanBuild and AbilityID == Ability.PeridotHarvester) {
			SupplyCheckOK = false;
			SupplyCheckX = XX;
			SupplyCheckY = YY;
			with(BuildPeridotSupply) {
				if(Plr != Game.NeutralPlayer) continue;
				if(point_distance(x, y, other.SupplyCheckX, other.SupplyCheckY) <= 96) { other.SupplyCheckOK = true; break; }
			}
			CanBuild = SupplyCheckOK;
		}
		
		if(CanBuild) {
			Plr.Cash -= Game.AbilitiesPrice[AbilityID];
			
			var BuildObj = (AbilityID == Ability.CommandCenter ? BuildCommandCenter : BuildPeridotHarvester);
			
			var Unit = create(BuildFrame, XX, YY);
			Unit.Building = BuildObj;
			Unit.ProgressSpeed = 1.6 / Game.AbilitiesTime[AbilityID];
			Unit.Plr = Plr;
			Unit.Dir = D;
			// Маска = реальный размер здания (иначе можно накладывать здания друг на друга)
			Unit.mask_index = BuildSpr;
			// HP пропорционален проценту стройки (полный HP — только после постройки)
			Unit.MaxHP = (AbilityID == Ability.CommandCenter ? 3000 : 1000);
			Unit.HP = 1;
		
			Target = Unit;
			// Едем к краю постройки (не в центр — иначе упрёмся в коллизию)
			var BRange = max(sprite_get_width(BuildSpr), sprite_get_height(BuildSpr)) / 2 + 16;
			var AppDir = point_direction(Unit.x, Unit.y, x, y);
			ToX = Unit.x + lengthdir_x(BRange - 4, AppDir);
			ToY = Unit.y + lengthdir_y(BRange - 4, AppDir);
		}
	break;
}