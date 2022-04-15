-------------------------------------------------
-- Net Speed Widget for Awesome Window Manager
-- Shows current upload/download speed
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/net-speed-widget

-- @author Pavel Makhov
-- @copyright 2020 Pavel Makhov
-------------------------------------------------

local watch = require("awful.widget.watch")
local wibox = require("wibox")

local HOME_DIR = os.getenv("HOME")
local WIDGET_DIR = HOME_DIR .. "/.config/awesome/widget/net-speed-widget/"
local ICONS_DIR = WIDGET_DIR .. "icons/"
local beautiful = require("beautiful")

local net_speed_widget =
    wibox.widget {
    {
        id = "rx_speed",
        forced_width = 70,
        font = beautiful.iconfont,
        align = "right",
        widget = wibox.widget.textbox
    },
    {
        id = "tx_speed",
        font = beautiful.iconfont,
        forced_width = 70,
        align = "left",
        widget = wibox.widget.textbox
    },
    {
        font = beautiful.iconfont,
        text = "   ",
        widget = wibox.widget.textbox
    },
    layout = wibox.layout.fixed.horizontal,
    set_rx_text = function(self, new_rx_speed)
        self:get_children_by_id("rx_speed")[1]:set_text(tostring(new_rx_speed .. "  "))
    end,
    set_tx_text = function(self, new_tx_speed)

        self:get_children_by_id("tx_speed")[1]:set_text(tostring("   " .. new_tx_speed .. "  "))
    end
}

local prev_rx = 0
local prev_tx = 0

local function convert_to_h(bytes)
    local speed
    local dim
    local bits = bytes * 8
    if bits < 1000 then
        speed = bits
        dim = "b/s"
    elseif bits < 1000000 then
        speed = bits / 1000
        dim = "k"
    elseif bits < 1000000000 then
        speed = bits / 1000000
        dim = "m"
    elseif bits < 1000000000000 then
        speed = bits / 1000000000
        dim = "g"
    else
        speed = tonumber(bits)
        dim = "b/s"
    end
    return math.floor(speed + 0.5) .. dim
end

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

local function worker(user_args)
    local args = user_args or {}

    local interface = args.interface or "*"
    local timeout = args.timeout or 1

    local update_widget = function(widget, stdout)
        local cur_vals = split(stdout, "\r\n")

        local cur_rx = 0
        local cur_tx = 0

        for i, _ in ipairs(cur_vals) do
            if i % 2 == 1 then
                cur_rx = cur_rx + cur_vals[i]
            end
            if i % 2 == 0 then
                cur_tx = cur_tx + cur_vals[i]
            end
        end

        local speed_rx = cur_rx - prev_rx
        local speed_tx = cur_tx - prev_tx

        widget:set_rx_text(convert_to_h(speed_rx))
        widget:set_tx_text(convert_to_h(speed_tx))

        prev_rx = cur_rx
        prev_tx = cur_tx
    end

    watch(
        string.format([[bash -c "cat /sys/class/net/%s/statistics/*_bytes"]], interface),
        timeout,
        update_widget,
        net_speed_widget
    )

    return net_speed_widget
end

return setmetatable(
    net_speed_widget,
    {
        __call = function(_, ...)
            return worker(...)
        end
    }
)
