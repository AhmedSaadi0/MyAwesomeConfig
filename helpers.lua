local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

local helpers = {}

function helpers.set_widget_block(args)
    local widget = args.widget

    local left = args.left or 0
    local right = args.right or 0
    local top = args.top or 0
    local bottom = args.bottom or 0
    local shape = args.shape or gears.shape.rectangle
    local fg = args.fg or beautiful.fg_normal
    local bg = args.bg or beautiful.widget_bg
    local font = args.font or beautiful.iconfont

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
        shape = shape,
        -- shape = gears.shape.rounded_bar,
        -- shape = function(cr, width, height)
        -- 	gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
        -- end,
        fg = fg,
        font = font,
        bg = bg,
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

-- Create rounded rectangle shape (in one line)

helpers.rrect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
    end
end

function helpers.colorize_text(txt, fg, font)
    if fg == nil then
        fg = beautiful.fg_normal
    end
    if font == nil then
        font = beautiful.iconfont
    end

    return "<span foreground='" .. fg .. "' font='" .. font .. "'>" .. txt .. "</span>"
end

function helpers.add_hover_cursor(w, hover_cursor)
    local original_cursor = "left_ptr"

    w:connect_signal(
        "mouse::enter",
        function()
            local w = _G.mouse.current_wibox
            if w then
                w.cursor = hover_cursor
            end
        end
    )

    w:connect_signal(
        "mouse::leave",
        function()
            local w = _G.mouse.current_wibox
            if w then
                w.cursor = original_cursor
            end
        end
    )
end

function helpers.add_text(txt, bg)
    return wibox.widget {
        markup = helpers.colorize_text(txt, bg),
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }
end

helpers.rrect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

function helpers.vertical_pad(height)
    return wibox.widget {
        forced_height = height,
        layout = wibox.layout.fixed.vertical
    }
end

return helpers
