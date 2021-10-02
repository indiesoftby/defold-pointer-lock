local M = {}

M.DISPLAY_WIDTH = tonumber(sys.get_config("display.width"))
M.DISPLAY_HEIGHT = tonumber(sys.get_config("display.height"))

M.cursor_x = M.DISPLAY_WIDTH / 2
M.cursor_y = M.DISPLAY_HEIGHT / 2
M.cursor_on = true
M.pointer_locked = false

function M.transform_action(action_id, action)
    action.x = M.cursor_x
    action.y = M.cursor_y

    if not M.pointer_locked or not M.cursor_on then
        action_id = nil
    end

    return action_id, action
end

return M