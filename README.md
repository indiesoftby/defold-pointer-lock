[![Pointer Lock Logo](cover.png)](https://github.com/indiesoftby/defold-pointer-lock)

# Pointer Lock for Defold

If you want to make a first-person 3D game with Defold, then you need this extension.

Pointer Lock simplifies mouse locking to access mouse events even when the cursor goes past the boundary of the window or screen. For example, your users can continue to rotate or manipulate a 3D model by moving the mouse without end. Without Pointer Lock, the rotation or manipulation stops the moment the pointer reaches the edge of the window or screen.

## Demo

**[Check out the web demo](https://indiesoftby.github.io/defold-pointer-lock/)** to test Pointer Lock on your desktop and fly through the included 3D scene.



## Supported Platforms

| Platform | Status | Known Things |
| -------- | ------ | ------------ |
| Browser (HTML5) | Supported ✅ (Desktop-only!) | The cursor isn't placed in the center of the view when it's locked. The cursor is automatically reset when escape is pressed. |
| macOS | Not Tested ℹ️ | |
| Linux | Not Tested ℹ️ | |
| Windows | Supported ✅ | When cursor is locked (`cursor.pointer_locked` is `true`), the OS cursor is placed in the center of the view and cannot be moved. The cursor is invisible in this state. |

## Installation & Usage

You can use it in your own project by adding this project as a [Defold library dependency](http://www.defold.com/manuals/libraries/). Open your `game.project` file and in the dependencies field under project add the ZIP file of a [specific release](https://github.com/indiesoftby/defold-pointer-lock/releases).

Then, add the `pointer_lock/pointer_lock.script` component to the bootstrap collection. Run your game and try to click anywhere to check that the cursor is locked. Press `key_esc` to unlock the cursor.

The `pointer_lock/cursor.lua` module contains the current status:

```lua
-- Is the pointer locked?
cursor.pointer_locked = false

-- Virtual in-game cursor
cursor.cursor_on = true
cursor.cursor_x = 0
cursor.cursor_y = 0
```

Pass `on_input` arguments to the `cursor.transform_input` function to convert input data into the virtual in-game cursor system:

```lua
function on_input(self, action_id, action)
    action_id, action = cursor.transform_input(action_id, action)
end
```

## License

MIT.

The asset cover uses [an image by Rostislav Uzunov](https://www.pexels.com/photo/purple-and-pink-diamond-on-blue-background-5011647/). Compass rose is generated with [Compass Rose Generator](https://watabou.itch.io/compass-rose-generator).
