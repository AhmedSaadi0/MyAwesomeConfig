local wibox = require("wibox")
local helpers = require("helpers")
local awful = require("awful")
local beautiful = require("beautiful")
local watch = awful.widget.watch
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local function create_slider()
    local core_slider =
        wibox.widget {
        nil,
        {
            id = "core",
            max_value = 100,
            value = 10,
            forced_height = beautiful.slider_forced_height,
            color = beautiful.slider_color,
            background_color = beautiful.slider_background_color,
            shape = gears.shape.rounded_rect,
            widget = wibox.widget.progressbar
        },
        nil,
        expand = "none",
        layout = wibox.layout.align.vertical
    }
    return core_slider
end

local function create_core(args)
    local text = args.text
    local slider = args.slider

    local core =
        helpers.create_slider_meter_widget {
        text = text,
        slider = slider,
        slider_right = dpi(70),
        slider_top = dpi(23)
    }

    return core
end

local function factory(args)
    local font = args.font or beautiful.uifont
    local header_bg = args.header_bg or beautiful.header_bg
    local bg = args.bg or beautiful.bg_normal
    local border_width = args.border_width or beautiful.control_border_width
    local border_color = args.border_color or beautiful.border_focus

    local shape = args.shape or function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
        end

    local number_text_widget =
        wibox.widget {
        text = "0",
        font = font,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local hardware_header =
        wibox.widget {
        text = "حرارة الاجهزة",
        font = font,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local slider_composite = create_slider()
    local composite =
        create_core {
        text = "المركب",
        slider = slider_composite
    }

    local slider_sensor_1 = create_slider()
    local sensor_1 =
        create_core {
        text = "الحساس 1",
        slider = slider_sensor_1
    }

    local slider_sensor_2 = create_slider()
    local sensor_2 =
        create_core {
        text = "الحساس 2",
        slider = slider_sensor_2
    }

    local slider_0 = create_slider()
    local core_0 =
        create_core {
        text = "النواة 1",
        slider = slider_0
    }

    local slider_1 = create_slider()
    local core_1 =
        create_core {
        text = "النواة 2",
        slider = slider_1
    }

    local slider_2 = create_slider()
    local core_2 =
        create_core {
        text = "النواة 3",
        slider = slider_2
    }

    local slider_3 = create_slider()
    local core_3 =
        create_core {
        text = "النواة 4",
        slider = slider_3
    }

    local slider_4 = create_slider()
    local core_4 =
        create_core {
        text = "النواة 5",
        slider = slider_4
    }

    local slider_5 = create_slider()
    local core_5 =
        create_core {
        text = "النواة 6",
        slider = slider_5
    }

    local detailed_widget =
        wibox.widget {
        layout = wibox.layout.fixed.vertical,
        helpers.add_margin {
            widget = {
                {
                    {
                        {
                            hardware_header,
                            left = dpi(24),
                            top = dpi(15),
                            bottom = dpi(15),
                            right = dpi(24),
                            widget = wibox.container.margin
                        },
                        bg = header_bg,
                        widget = wibox.container.background
                    },
                    layout = wibox.layout.fixed.vertical,
                    composite,
                    sensor_1,
                    sensor_2,
                    core_0,
                    core_1,
                    core_2,
                    core_3,
                    core_4,
                    core_5
                },
                bg = bg,
                -- shape = shape,
                widget = wibox.container.background
            },
            bottom = dpi(10)
        }
    }

    local popup =
        awful.popup {
        ontop = true,
        visible = false,
        shape = shape,
        border_width = border_width,
        border_color = border_color,
        maximum_width = 300,
        offset = {y = 10},
        widget = detailed_widget
    }

    watch(
        "sensors",
        5,
        function(_, stdout)
            for line in stdout:gmatch("[^\r\n]+") do
                if line:match("temp1") then
                    number_text_widget.text = helpers.trim(string.gsub(line, "temp1:+", ""))
                elseif line:match("Composite") then
                    local degree = helpers.trim(string.match(line, "%d+"))
                    slider_composite.core:set_value(math.floor(degree))
                elseif line:match("Sensor 1") then
                    local degree = helpers.trim(string.match(string.gsub(line, "Sensor 1:", ""), "%d+"))
                    slider_sensor_1.core:set_value(math.floor(degree))
                elseif line:match("Sensor 2") then
                    local degree = helpers.trim(string.match(string.gsub(line, "Sensor 2:", ""), "%d+"))
                    slider_sensor_2.core:set_value(math.floor(degree))
                elseif line:match("Core 0") then
                    local degree = helpers.trim(string.match(string.gsub(line, "Core 0:", ""), "%d+"))
                    slider_0.core:set_value(math.floor(degree))
                elseif line:match("Core 1") then
                    local degree = helpers.trim(string.match(string.gsub(line, "Core 1:", ""), "%d+"))
                    slider_1.core:set_value(math.floor(degree))
                elseif line:match("Core 2") then
                    local degree = helpers.trim(string.match(string.gsub(line, "Core 2:", ""), "%d+"))
                    slider_2.core:set_value(math.floor(degree))
                elseif line:match("Core 3") then
                    local degree = helpers.trim(string.match(string.gsub(line, "Core 3:", ""), "%d+"))
                    slider_3.core:set_value(math.floor(degree))
                elseif line:match("Core 4") then
                    local degree = helpers.trim(string.match(string.gsub(line, "Core 4:", ""), "%d+"))
                    slider_4.core:set_value(math.floor(degree))
                elseif line:match("Core 5") then
                    local degree = helpers.trim(string.match(string.gsub(line, "Core 5:", ""), "%d+"))
                    slider_5.core:set_value(math.floor(degree))
                end
            end
        end
    )

    number_text_widget:connect_signal(
        "button::press",
        function()
            if popup.visible then
                popup.visible = not popup.visible
            else
                popup:move_next_to(mouse.current_widget_geometry)
            end
        end
    )

    return number_text_widget
end

return factory
