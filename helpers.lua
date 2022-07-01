local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local timer = require("gears.timer")
local dpi = beautiful.xresources.apply_dpi

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

function helpers.right_rounded_rect(radius)
    return function(cr, w, h)
        gears.shape.partially_rounded_rect(cr, w, h, false, true, true, false, radius)
    end
end

function helpers.left_rounded_rect(radius)
    return function(cr, w, h)
        gears.shape.partially_rounded_rect(cr, w, h, true, false, false, true, radius)
    end
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

function helpers.trim(str)
    return str:gsub("%s+", "")
end

function helpers.create_slider_meter_widget(args)
    local image = args.image
    local text = args.text

    local slider = args.slider
    local hight = args.hight

    local left = args.left or dpi(24)
    local right = args.right or dpi(24)

    local slider_top = args.slider_top or dpi(20)
    local slider_bottom = args.slider_bottom or dpi(12)
    local slider_left = args.slider_left or dpi(0)
    local slider_right = args.slider_right or dpi(40)

    local text_top = args.text_top or dpi(12)
    local text_bottom = args.text_bottom or dpi(12)
    local text_left = args.text_left or dpi(0)
    local text_right = args.text_right or dpi(0)

    local image_top = args.image_top or dpi(12)
    local image_bottom = args.image_bottom or dpi(12)
    local image_left = args.image_left or dpi(0)
    local image_right = args.image_right or dpi(0)

    local cpu_meter =
        wibox.widget {
        {
            {
                {
                    image = image,
                    resize = true,
                    widget = wibox.widget.imagebox
                },
                point = function(geo, args)
                    return {
                        x = args.parent.width - geo.width,
                        y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
                    }
                end,
                top = image_top,
                bottom = image_bottom,
                left = image_left,
                right = image_right,
                widget = wibox.container.margin
            },
            {
                {
                    text = text,
                    font = beautiful.uifont,
                    align = "center",
                    valign = "center",
                    widget = wibox.widget.textbox
                },
                point = function(geo, args)
                    return {
                        x = args.parent.width - geo.width,
                        y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
                    }
                end,
                top = text_top,
                bottom = text_bottom,
                left = text_left,
                right = text_right,
                widget = wibox.container.margin
            },
            {
                slider,
                top = slider_top,
                bottom = slider_bottom,
                left = slider_left,
                right = slider_right,
                widget = wibox.container.margin
            },
            layout = wibox.layout.manual
        },
        left = left,
        right = right,
        forced_height = hight or dpi(48),
        widget = wibox.container.margin
    }

    local myclock_t = awful.tooltip {}

    myclock_t:add_to_object(cpu_meter)

    cpu_meter:connect_signal(
        "mouse::enter",
        function()
            myclock_t.text = slider.core:get_value()
        end
    )

    return cpu_meter
end

return helpers
