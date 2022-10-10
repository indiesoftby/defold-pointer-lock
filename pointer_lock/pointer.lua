local M = {}

M.DISPLAY_WIDTH = tonumber(sys.get_config("display.width"))
M.DISPLAY_HEIGHT = tonumber(sys.get_config("display.height"))

M.locked = false

--- Virtual Cursor
-- X/Y
M.cursor_x = M.DISPLAY_WIDTH / 2
M.cursor_y = M.DISPLAY_HEIGHT / 2
-- Visible or not
M.cursor_visible = true
-- GUI Render Order. 15 is top.
M.cursor_render_order = 15

function M.transform_input(action_id, action)
    action.x = M.cursor_x
    action.y = M.cursor_y

    if not M.locked or not M.cursor_visible then
        action_id = nil
    end

    return action_id, action
end

return M