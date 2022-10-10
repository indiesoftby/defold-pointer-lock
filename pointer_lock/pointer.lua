local M = {}

M.DISPLAY_WIDTH = tonumber(sys.get_config("display.width"))
M.DISPLAY_HEIGHT = tonumber(sys.get_config("display.height"))

M.locked = false

--- Virtual Cursor
-- X/Y
M.cursor_x = M.DISPLAY_WIDTH / 2
M.cursor_y = M.DISPLAY_HEIGHT / 2
-- Visible or not
M.cursor_visible = false
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

function M.update_cursor_position(action)
    local x = M.cursor_x
    local y = M.cursor_y

    x = math.min(math.max(x + action.dx, 0), M.DISPLAY_WIDTH)
    y = math.min(math.max(y + action.dy, 0), M.DISPLAY_HEIGHT)

    M.cursor_x = x
    M.cursor_y = y
end

function M.update_lock_state()
    local locked = window.get_mouse_lock()
    if locked ~= M.locked then
        -- DEBUG
        -- print("pointer.locked changed: ", locked)

        -- do something?...
    end
    M.locked = locked
end


return M