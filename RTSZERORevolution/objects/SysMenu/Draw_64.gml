draw_clear(P0);

draw_sprite_ext(sprGuiLogo, 0, 256, 36, 2, 2, 0, PF, 1);

gui_font(fn_default, fa_right, fa_bottom);
gui_text(510, 382, Game.Copyright, 1, PF, 1);

gui_font(fn_default, fa_middle, fa_middle);
gui_text(256, 64, "RTSZero", 2, PF, 1);
gui_text(256, 80, "Версия: " + Game.Version, 1, P8, 1);

switch(Section) {
    #region Основное меню
    case 0:
        if(gui_buttonText(156, 120, 200, 16, "Создать игру", 0)) {
            instance_change(SysServer, true);
        }
        if(gui_buttonText(156, 140, 200, 16, "Присоединиться", 0)) {
            instance_change(SysClient, true);
        }

        if(gui_buttonText(156, 170, 200, 16, "Редактор карт", 0)) {
            instance_change(SysEditor, true);
        }

        if(gui_buttonText(156, 190, 200, 16, "Настройки", 0)) {
            Section = 1;
        }
        if(gui_buttonText(156, 220, 200, 16, "Выход", 0)) {
            game_end();
        }
        
        // ===== КНОПКА "Д" — запуск второй копии =====
        if(gui_buttonText(4, 4, 12, 12, "Д", 0)) {
            show_debug_message("=== Button Д pressed ===");
            show_debug_message("AppPath: '" + string(Game.AppPath) + "'");
            show_debug_message("AppArgs: '" + string(Game.AppArgs) + "'");
            show_debug_message("working_directory: '" + working_directory + "'");
            
            var exePath = Game.AppPath;
            
            // Если AppPath пустой или файл не существует — ищем EXE вручную
            if (exePath == "" or !file_exists(exePath)) {
                var possiblePaths = [
                    working_directory + "RTSZero.exe",
                    working_directory + "RTSZero.win",
                    working_directory + "game.exe"
                ];
                
                for (var i = 0; i < array_length(possiblePaths); i++) {
                    if (file_exists(possiblePaths[i])) {
                        exePath = possiblePaths[i];
                        break;
                    }
                }
            }
            
            show_debug_message("Final exePath: '" + string(exePath) + "'");
            
            if (file_exists(exePath)) {
                game_launch(0);   // ← универсальная функция GameMaker
                show_debug_message("=== Second instance launched ===");
            } else {
                show_debug_message("=== EXE not found! ===");
                show_message("Не удалось найти EXE игры. Запустите игру через собранный EXE, а не из IDE.");
            }
        }
        // ============================================
    break;
    #endregion
    #region Настройки
    case 1:
        if(gui_buttonText(156, 140, 200, 16, Game.Username, 0)) {
            var str = get_string("Введите новый никнейм:", Game.Username);
            if(str != "") Game.Username = str;
        }
        if(gui_buttonText(156, 190, 200, 16, "Назад", 0)) {
            Section = 0;
        }
        
        gui_font(fn_default, fa_left, fa_bottom);
        gui_text(156, 136, "Ваш никнейм:", 1, PF, 1);
    break;
    #endregion
}