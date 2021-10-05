local M = {}

-- Variables
M.display_width = tonumber(sys.get_config("display.width"))
M.display_height = tonumber(sys.get_config("display.height"))
M.aspect_ratio = M.display_width/M.display_height
M.FOV = 42.5
M.NEAR = 1
M.FAR = 5000

-- Helpers
local IDENTITY_MAT4 = vmath.matrix4()
M.FORWARD = vmath.vector3(0, 0, -1)
M.RIGHT = vmath.vector3(1, 0, 0)
M.UP = vmath.vector3(0, 1, 0)

-- Camera
M.view_position = vmath.vector3()
M.view_front = vmath.vector3()
M.view_world_up = vmath.vector3()

function M.reset()
    M.view_position = vmath.vector3(0, 0, 0)
    M.view_front = vmath.vector3(0, 0, -1)
    M.view_world_up = vmath.vector3(0, 1, 0)
end

M.reset()

function M.update_camera(yaw, pitch)
    M.view_world_up = vmath.vector3(0, 1, 0)

    local front = vmath.vector3()
    front.x = math.cos(math.rad(yaw)) * math.cos(math.rad(pitch))
    front.y = math.sin(math.rad(pitch))
    front.z = math.sin(math.rad(yaw)) * math.cos(math.rad(pitch))
    M.view_front = vmath.normalize(front)

    -- Re-calculate the Right and Up vector,
    -- plus normalize the vectors, because their length gets closer to 0 the more
    -- you look up or down which results in slower movement.
    M.view_right = vmath.normalize(vmath.cross(M.view_front, M.view_world_up)) 
    M.view_up = vmath.normalize(vmath.cross(M.view_right, M.view_front))
end

function M.update_display(w, h)
    M.display_width = math.max(1, w)
    M.display_height = math.max(1, h)
    M.aspect_ratio = w / h
end

function M.camera_view()
    return vmath.matrix4_look_at(M.view_position, M.view_position + M.view_front, M.view_world_up)
end

function M.camera_perspective()
    return vmath.matrix4_perspective(math.rad(M.FOV), M.aspect_ratio, M.NEAR, M.FAR)
end

return M