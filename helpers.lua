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

    local visible = args.visible

    local forced_height = args.forced_height
    local forced_width = args.forced_width

    local bgimage = args.bgimage or nil

    local block = {
        {
            widget,
            left = left,
            right = right,
            top = top,
            bottom = bottom,
            widget = wibox.container.margin
        },
        shape = shape,
        bgimage = bgimage,
        fg = fg,
        bg = bg,
        visible = visible,
        font = font,
        forced_height = forced_height,
        forced_width = forced_width,
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

function helpers.rrect(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius or beautiful.groups_radius)
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

function helpers.add_text(txt, bg, font)
    return wibox.widget {
        markup = helpers.colorize_text(txt, bg, font),
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

function helpers.split(source, sep)
    local result, i = {}, 1
    while true do
        local a, b = source:find(sep)
        if not a then break end
        local candidat = source:sub(1, a - 1)
        if candidat ~= "" then 
            result[i] = candidat
        end i=i+1
        source = source:sub(b + 1)
    end
    if source ~= "" then 
        result[i] = source
    end
    return result
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

function helpers.create_gradient_color(args)
    local type = args.type or "linear"

    local from_color = args.from_color or "#fe67a9"
    local to_color = args.to_color or "#7766fb"

    local from = args.from or {0, 0}
    local to = args.to or {200, 200}

    local stops = args.stops or {{0.3, from_color}, {1, to_color}}

    return {
        type = type,
        from = from,
        to = to,
        stops = stops
    }
end

function helpers.add_margin(args)
    local widget = args.widget
    local top = args.top or dpi(0)
    local bottom = args.bottom or dpi(0)
    local left = args.left or dpi(0)
    local right = args.right or dpi(0)

    local visible = args.visible
    local id = args.id

    local margin = {
        widget,
        id = id,
        top = top,
        bottom = bottom,
        left = left,
        right = right,
        visible = visible,
        widget = wibox.container.margin
    }
    return margin
end

function helpers.create_weather_detailed(args)
    local text_font = args.font or beautiful.uifont
    local icon_font = args.font or beautiful.iconfont

    local visible = args.visible

    local temperature_id = args.temperature_id or "temperature_id"
    local sky_status_id = args.sky_status_id or "sky_status_id"
    local weather_icon_id = args.weather_icon_id or "weather_icon_id"
    local temperature_time_id = args.temperature_time_id or "temperature_time_id"
    local temperature_date_id = args.temperature_date_id or "temperature_date_id"
    local temperature_city_id = args.temperature_city_id or "temperature_city_id"
    local h_l_temperature_id = args.h_l_temperature_id or "h_l_temperature_id"
    local moonrise_id = args.moonrise_id or "moonrise_id"
    local sunrise_id = args.sunrise_id or "sunrise_id"

    local weather_details =
        wibox.widget {
        layout = wibox.layout.manual,
        visible = visible,
        forced_height = dpi(110),
        forced_width = dpi(250),
        {
            -- اليسار
            point = function(geo, args)
                return {
                    x = 0,
                    y = 0 --(args.parent.height / 2 + (geo.height / 2)) - geo.height
                }
            end,
            layout = wibox.layout.fixed.horizontal,
            {
                layout = wibox.layout.manual,
                {
                    point = function(geo, args)
                        return {
                            x = 0,
                            y = 0 --(args.parent.height / 2 + (geo.height / 2)) - geo.height
                        }
                    end,
                    layout = wibox.layout.fixed.vertical,
                    {
                        text = "",
                        font = "JF Flat 20",
                        align = "left",
                        id = temperature_time_id,
                        widget = wibox.widget.textbox
                    },
                    {
                        text = "",
                        font = "JF Flat 11",
                        align = "left",
                        id = temperature_date_id,
                        widget = wibox.widget.textbox
                    },
                    helpers.add_margin {
                        widget = {
                            markup = "",
                            font = icon_font,
                            align = "left",
                            id = sunrise_id,
                            widget = wibox.widget.textbox
                        }
                        -- top = dpi(5)
                    },
                    helpers.add_margin {
                        widget = {
                            markup = "",
                            font = icon_font,
                            align = "left",
                            id = moonrise_id,
                            widget = wibox.widget.textbox
                        }
                        -- top = dpi(5)
                    }
                },
                {
                    point = function(geo, args)
                        return {
                            x = 0,
                            y = args.parent.height - geo.height
                        }
                    end,
                    layout = wibox.layout.fixed.vertical,
                    {
                        text = "",
                        font = "JF Flat 11",
                        align = "left",
                        id = temperature_city_id,
                        widget = wibox.widget.textbox
                    }
                }
            }
        },
        {
            -- اليمين
            point = function(geo, args)
                return {
                    x = args.parent.width - geo.width,
                    y = 0
                }
            end,
            layout = wibox.layout.fixed.horizontal,
            {
                layout = wibox.layout.fixed.vertical,
                {
                    layout = wibox.layout.fixed.horizontal,
                    helpers.add_margin {
                        widget = {
                            text = "",
                            id = weather_icon_id,
                            font = icon_font,
                            -- align = "left",
                            widget = wibox.widget.textbox
                        },
                        right = dpi(5)
                    },
                    {
                        text = "",
                        id = sky_status_id,
                        font = text_font,
                        align = "left",
                        widget = wibox.widget.textbox
                    }
                },
                {
                    text = "",
                    font = "JF Flat 40",
                    align = "right",
                    id = temperature_id,
                    widget = wibox.widget.textbox
                },
                helpers.add_margin {
                    widget = {
                        text = "",
                        font = text_font,
                        align = "right",
                        id = h_l_temperature_id,
                        widget = wibox.widget.textbox
                    },
                    right = dpi(3)
                }
            }
        }
    }

    return weather_details
end

function helpers.create_music_widget(args)
    local text_font = args.font or beautiful.uifont
    local icon_font = args.font or beautiful.iconfont

    local widget_bg = args.widget_bg or beautiful.widget_bg
    local widget_fg = args.widget_fg or beautiful.fg_normal

    local icon_bg = args.icon_bg
    local icon_fg = args.icon_fg

    local inner_image_shape = args.shape or helpers.rrect(dpi(11))

    local buttons_group_shape = args.shape or helpers.rrect(dpi(11))

    local buttons_group_bg_color = args.buttons_group_bg_color or widget_bg
    local buttons_group_fg_color = args.buttons_group_fg_color or widget_fg

    local detailed_widget =
        wibox.widget {
        layout = wibox.layout.ratio.horizontal,
        helpers.set_widget_block {
            widget = helpers.set_widget_block {
                widget = {
                    id = "image_id",
                    image = beautiful.music_back,
                    horizontal_fit_policy = "fit",
                    vertical_fit_policy = "fit",
                    valign = "center",
                    align = "center",
                    resize = true,
                    widget = wibox.widget.imagebox
                },
                shape = inner_image_shape
                -- bg = "#2b337c"
            },
            right = dpi(0),
            left = dpi(12),
            top = dpi(12),
            bottom = dpi(12),
            bg = widget_bg,
            fg = widget_fg
        },
        helpers.set_widget_block {
            widget = {
                layout = wibox.layout.fixed.vertical,
                {
                    layout = wibox.layout.manual,
                    forced_height = dpi(40),
                    {
                        layout = wibox.layout.fixed.horizontal,
                        point = function(geo, args)
                            return {
                                x = args.parent.width - geo.width - dpi(12),
                                y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
                            }
                        end,
                        {
                            text = "🎝",
                            font = icon_font,
                            id = "music_icon_id",
                            align = "center",
                            valign = "center",
                            widget = wibox.widget.textbox
                        }
                    }
                },
                helpers.add_margin {
                    widget = {
                        layout = wibox.container.scroll.horizontal,
                        -- max_size = 100,
                        -- fps = 60,
                        step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                        speed = 100,
                        {
                            id = "title_id",
                            text = "لا توجد موسيقى قيد التشغيل",
                            font = text_font,
                            align = "center",
                            valign = "center",
                            widget = wibox.widget.textbox
                        }
                    },
                    right = dpi(12),
                    left = dpi(12),
                    top = -5
                },
                helpers.add_margin {
                    widget = {
                        layout = wibox.container.scroll.horizontal,
                        -- max_size = 100,
                        -- forced_height = dpi(5),
                        -- fps = 60,
                        step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                        speed = 100,
                        {
                            id = "artist_id",
                            text = "لا يوجد فنان",
                            font = text_font:sub(1, -3) .. " 9", --"JF Flat 9",
                            align = "left",
                            valign = "left",
                            widget = wibox.widget.textbox
                        }
                    },
                    right = dpi(12),
                    top = dpi(8),
                    bottom = dpi(8),
                    left = dpi(12)
                },
                helpers.add_margin {
                    widget = helpers.set_widget_block {
                        widget = {
                            layout = wibox.layout.manual,
                            {
                                point = function(geo, args)
                                    return {
                                        x = 10,
                                        y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
                                    }
                                end,
                                layout = wibox.layout.fixed.horizontal,
                                {
                                    id = "back_button_id",
                                    text = "",
                                    font = icon_font,
                                    align = "center",
                                    valign = "center",
                                    widget = wibox.widget.textbox
                                }
                            },
                            {
                                point = function(geo, args)
                                    return {
                                        x = (args.parent.width / 3) - 2,
                                        y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
                                    }
                                end,
                                layout = wibox.layout.fixed.horizontal,
                                {
                                    id = "play_button_id",
                                    text = "",
                                    font = icon_font,
                                    align = "center",
                                    valign = "center",
                                    widget = wibox.widget.textbox
                                }
                            },
                            {
                                point = function(geo, args)
                                    return {
                                        x = args.parent.width - (args.parent.width / 3) - geo.width,
                                        y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
                                    }
                                end,
                                layout = wibox.layout.fixed.horizontal,
                                {
                                    id = "stop_button_id",
                                    text = "",
                                    font = icon_font,
                                    align = "center",
                                    valign = "center",
                                    widget = wibox.widget.textbox
                                }
                            },
                            {
                                point = function(geo, args)
                                    return {
                                        x = args.parent.width - geo.width - 10,
                                        y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
                                    }
                                end,
                                layout = wibox.layout.fixed.horizontal,
                                {
                                    id = "next_button_id",
                                    text = "",
                                    font = icon_font,
                                    align = "center",
                                    valign = "center",
                                    widget = wibox.widget.textbox
                                }
                            }
                        },
                        bg = buttons_group_bg_color,
                        fg = buttons_group_fg_color,
                        forced_height = dpi(27),
                        shape = buttons_group_shape
                    },
                    bottom = dpi(0),
                    top = dpi(10),
                    right = dpi(18),
                    left = dpi(12)
                }
            },
            bg = widget_bg,
            fg = widget_fg
        }
    }

    detailed_widget:adjust_ratio(2, 0.11, 0.33, 0.22)

    return detailed_widget
end

return helpers
