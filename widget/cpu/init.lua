-------------------------------------------------
-- CPU Widget for Awesome Window Manager
-- Shows the current CPU utilization
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/cpu-widget

-- @author Pavel Makhov
-- @copyright 2020 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")

local CMD =
    [[sh -c "grep '^cpu.' /proc/stat; ps -eo '%p|%c|%C|' -o "%mem" -o '|%a' --sort=-%cpu ]] ..
    [[| head -11 | tail -n +2"]]

local HOME_DIR = os.getenv("HOME")
local WIDGET_DIR = HOME_DIR .. "/.config/awesome/awesome-wm-widgets/cpu-widget"

local cpu_widget = {}
local cpu_rows = {
    spacing = 4,
    layout = wibox.layout.fixed.vertical
}
local is_update = true
local process_rows = {
    layout = wibox.layout.fixed.vertical
}

-- Splits the string by separator
-- @return table with separated substrings
local function split(string_to_split, separator)
    if separator == nil then
        separator = "%s"
    end
    local t = {}

    for str in string.gmatch(string_to_split, "([^" .. separator .. "]+)") do
        table.insert(t, str)
    end

    return t
end

-- Checks if a string starts with a another string
local function starts_with(str, start)
    return str:sub(1, #start) == start
end

local function create_textbox(args)
    return wibox.widget {
        text = args.text,
        align = args.align or "left",
        markup = args.markup,
        forced_width = args.forced_width or 40,
        widget = wibox.widget.textbox
    }
end

local function create_process_header(params)
    local res =
        wibox.widget {
        create_textbox {markup = "<b>PID</b>"},
        create_textbox {markup = "<b>Name</b>"},
        {
            create_textbox {markup = "<b>%CPU</b>"},
            create_textbox {markup = "<b>%MEM</b>"},
            params.with_action_column and create_textbox {forced_width = 20} or nil,
            layout = wibox.layout.align.horizontal
        },
        layout = wibox.layout.ratio.horizontal
    }
    res:ajust_ratio(2, 0.2, 0.47, 0.33)

    return res
end

local function create_kill_process_button()
    return wibox.widget {
        {
            id = "icon",
            image = WIDGET_DIR .. "/window-close-symbolic.svg",
            resize = false,
            opacity = 0.1,
            widget = wibox.widget.imagebox
        },
        widget = wibox.container.background
    }
end

local function worker(user_args)
    local args = user_args or {}

    local width = args.width or 50
    local step_width = args.step_width or 2
    local step_spacing = args.step_spacing or 1
    local color = args.color or beautiful.fg_normal
    local enable_kill_button = args.enable_kill_button or false
    local process_info_max_length = args.process_info_max_length or -1
    local timeout = args.timeout or 1
    local header_bg = args.header_bg or beautiful.header_bg

    local border_width = args.border_width or beautiful.control_border_width
    local border_color = args.border_color or beautiful.border_focus

    local font = args.font or beautiful.uifont

    local shape = args.shape or function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
        end

    local handle_shape = args.handle_shape or helpers.rrect(dpi(100))
    local bar_shape = args.handle_shape or beautiful.vol_bar_shape or helpers.rrect(dpi(11))
    local bar_height = args.bar_height or beautiful.vol_bar_height or dpi(1)
    local bar_color = args.bar_color or beautiful.vol_bar_color
    local bar_active_color = args.bar_active_color or beautiful.vol_bar_active_color
    local handle_color = args.handle_color or beautiful.vol_bar_handle_color
    local handle_width = args.handle_width or 0
    local handle_border_color = args.handle_border_color or beautiful.vol_handle_border_color
    local handle_border_width = args.handle_border_width or beautiful.vol_handle_border_width

    local hardware_header =
        wibox.widget {
        text = "استخدام المعالج",
        font = font,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local cpugraph_widget =
        wibox.widget {
        max_value = 100,
        background_color = "#00000000",
        forced_width = width,
        step_width = step_width,
        step_spacing = step_spacing,
        widget = wibox.widget.graph,
        color = "linear:0,0:0,20:0,#FF0000:0.3,#FFFF00:0.6," .. color
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
        widget = {}
    }

    -- Do not update process rows when mouse cursor is over the widget
    popup:connect_signal(
        "mouse::enter",
        function()
            is_update = false
        end
    )
    popup:connect_signal(
        "mouse::leave",
        function()
            is_update = true
        end
    )

    cpugraph_widget:buttons(
        awful.util.table.join(
            awful.button(
                {},
                1,
                function()
                    if popup.visible then
                        popup.visible = not popup.visible
                    else
                        popup:move_next_to(mouse.current_widget_geometry)
                    end
                end
            )
        )
    )

    --- By default graph widget goes from left to right, so we mirror it and push up a bit
    cpu_widget =
        wibox.widget {
        {
            cpugraph_widget,
            reflection = {horizontal = true},
            layout = wibox.container.mirror
        },
        bottom = 2,
        widget = wibox.container.margin
    }

    local cpus = {}
    watch(
        CMD,
        timeout,
        function(widget, stdout)
            local i = 1
            local j = 1
            for line in stdout:gmatch("[^\r\n]+") do
                if starts_with(line, "cpu") then
                    if cpus[i] == nil then
                        cpus[i] = {}
                    end

                    local name, user, nice, system, idle, iowait, irq, softirq, steal, _, _ =
                        line:match("(%w+)%s+(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)")

                    local total = user + nice + system + idle + iowait + irq + softirq + steal

                    local diff_idle = idle - tonumber(cpus[i]["idle_prev"] == nil and 0 or cpus[i]["idle_prev"])
                    local diff_total = total - tonumber(cpus[i]["total_prev"] == nil and 0 or cpus[i]["total_prev"])
                    local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

                    cpus[i]["total_prev"] = total
                    cpus[i]["idle_prev"] = idle

                    if i == 1 then
                        widget:add_value(diff_usage)
                    end

                    local row =
                        wibox.widget {
                        create_textbox {text = name},
                        create_textbox {text = math.floor(diff_usage) .. "%"},
                        {
                            max_value = 100,
                            bar_shape = bar_shape,
                            bar_height = bar_height,
                            bar_color = bar_color,
                            bar_active_color = bar_active_color,
                            bar_active_shape = bar_shape,
                            handle_color = handle_color,
                            handle_shape = handle_shape,
                            handle_border_color = handle_border_color,
                            handle_width = handle_width,
                            handle_border_width = handle_border_width,
                            value = diff_usage,
                            -- forced_height = 20,
                            forced_width = 150,
                            margins = dpi(3),
                            forced_height = beautiful.slider_forced_height,
                            color = beautiful.slider_color,
                            background_color = beautiful.slider_background_color,
                            shape = gears.shape.rounded_rect,
                            widget = wibox.widget.progressbar
                        },
                        layout = wibox.layout.ratio.horizontal
                    }
                    row:ajust_ratio(2, 0.15, 0.15, 0.7)
                    cpu_rows[i] = row
                    i = i + 1
                else
                    if is_update == true then
                        local columns = split(line, "|")

                        local pid = columns[1]
                        local comm = columns[2]
                        local cpu = columns[3]
                        local mem = columns[4]
                        local cmd = columns[5]

                        local kill_proccess_button = enable_kill_button and create_kill_process_button() or nil

                        local pid_name_rest =
                            wibox.widget {
                            create_textbox {text = pid},
                            create_textbox {text = comm},
                            {
                                create_textbox {text = cpu, align = "center"},
                                create_textbox {text = mem, align = "center"},
                                kill_proccess_button,
                                layout = wibox.layout.fixed.horizontal
                            },
                            layout = wibox.layout.ratio.horizontal
                        }
                        pid_name_rest:ajust_ratio(2, 0.2, 0.47, 0.33)

                        local row =
                            wibox.widget {
                            {
                                pid_name_rest,
                                top = 4,
                                bottom = 4,
                                widget = wibox.container.margin
                            },
                            widget = wibox.container.background
                        }

                        row:connect_signal(
                            "mouse::enter",
                            function(c)
                                c:set_bg(beautiful.bg_focus)
                            end
                        )
                        row:connect_signal(
                            "mouse::leave",
                            function(c)
                                c:set_bg(beautiful.bg_normal)
                            end
                        )

                        if enable_kill_button then
                            row:connect_signal(
                                "mouse::enter",
                                function()
                                    kill_proccess_button.icon.opacity = 1
                                end
                            )
                            row:connect_signal(
                                "mouse::leave",
                                function()
                                    kill_proccess_button.icon.opacity = 0.1
                                end
                            )

                            kill_proccess_button:buttons(
                                awful.util.table.join(
                                    awful.button(
                                        {},
                                        1,
                                        function()
                                            row:set_bg("#ff0000")
                                            awful.spawn.with_shell("kill -9 " .. pid)
                                        end
                                    )
                                )
                            )
                        end

                        awful.tooltip {
                            objects = {row},
                            mode = "outside",
                            preferred_positions = {"bottom"},
                            timer_function = function()
                                local text = cmd
                                if process_info_max_length > 0 and text:len() > process_info_max_length then
                                    text = text:sub(0, process_info_max_length - 3) .. "..."
                                end

                                return text:gsub("%s%-", "\n\t-"):gsub(":/", "\n\t\t:/") -- put arguments on a new line -- java classpath uses : to separate jars
                            end
                        }

                        process_rows[j] = row

                        j = j + 1
                    end
                end
            end
            popup:setup {
                layout = wibox.layout.fixed.vertical,
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
                {
                    {
                        cpu_rows,
                        {
                            orientation = "horizontal",
                            forced_height = 15,
                            color = beautiful.bg_focus,
                            widget = wibox.widget.separator
                        },
                        create_process_header {with_action_column = enable_kill_button},
                        process_rows,
                        layout = wibox.layout.fixed.vertical
                    },
                    margins = 8,
                    widget = wibox.container.margin
                }
            }
        end,
        cpugraph_widget
    )

    return cpu_widget
end

return setmetatable(
    cpu_widget,
    {
        __call = function(_, ...)
            return worker(...)
        end
    }
)
