local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

local helpers = {}

function helpers.set_widget_block(widget, fg, shape, left, right, top, bottom)
    if not left then
        left = 0
    end
    if not right then
        right = 0
    end
    if not top then
        top = 0
    end
    if not bottom then
        bottom = 0
    end
    if not shape then
        shape = gears.shape.rectangle
    end
    if not fg then
        fg = beautiful.fg_normal
    end

    local block = {
        {
            widget,
            left = left,
            right = right,
            top = top,
            bottom = bottom,
            widget = wibox.container.margin
        },
        forced_height = beautiful.widget_height,
        shape = gears.shape.rounded_bar,
        -- shape = function(cr, width, height)
		-- 	gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
		-- end,
        fg = fg,
        font = beautiful.iconfont,
        bg = beautiful.widget_bg,
        widget = wibox.container.background
    }
    return block
end

function helpers.set_space(space_size)
    local space =
        wibox.widget {
        forced_width = space_size,
        -- spacing = space_size,
        spacing_widget = wibox.widget.separator,
        layout = wibox.layout.flex.horizontal
    }
    return space
end


return helpers
