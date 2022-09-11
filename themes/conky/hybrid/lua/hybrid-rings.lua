--[[
Ring Meters by londonali1010 (2009)
Modified by La-Manoue (2016)
Automation template by popi (2017)
Modified by dirn (2020)

This script draws percentage meters as rings. It is fully customisable all options are described in the script.

IMPORTANT: if you are using the 'cpu' function, it will cause a segmentation fault if it tries to draw a ring straight away. 
    The if statement near the end of the script uses a delay to make sure that this doesn't happen. 
    It calculates the length of the delay by the number of updates since Conky started. 
    Generally, a value of 5s is long enough, so if you update Conky every 1s, use update_num > 5 in that if statement (the default). 
    If you only update Conky every 2s, you should change it to update_num > 3 conversely if you update Conky every 0.5s, 
    you should use update_num > 10. ALSO, if you change your Conky, is it best to use "killall conky conky" to update it, 
    otherwise the update_num will not be reset and you will get an error.

To call this script in Conky, use the following (assuming that you save this script to ~/.config/conky/hybrid/lua/hybrid-rings.lua):
	lua_load = '~/.config/conky/hybrid/lua/hybrid-rings.lua',
    lua_draw_hook_pre = 'conky_main'
]]

g_main_colour = "0xa8a8a8"
temp_colour = "0x9b30c8"
warn_text = "0x161925"

bg_colour = "0x555b67"

battery_circle_color = "0xe06c75"
ram_circle_color = "0xe06c75"
time_circle_color = "0xe06c75"

normal = "0x7ec7a2"
warn = "0xff7200"
crit = "0xff000d"
update_num_min = 3
home_dir = "/home/ahmed"

-- blue     | 0x3458eb
-- red      | 0xff1d2b
-- green    | 0x1dff22 - fff
-- pink     | 0xff1d9f
-- orange   | 0xff8523
-- skyblue  | 0x008cff
-- darkgray | 0x323232

settings_table = {
    -- cpu core temperature
    -- hwmon path /sys/bus/platform/devices/coretemp.0/hwmon/
    {
        name='platform',
        arg='coretemp.0/hwmon/hwmon4 temp 2',
        max=110,
        bg_colour=bg_colour,
        bg_alpha=0.5,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=140,
        radius=91,
        thickness=4,
        start_angle=180,
        end_angle=450,
        text_id=1
    },
    {
        name='platform',
        arg='coretemp.0/hwmon/hwmon4 temp 3',
        max=110,
        bg_colour=bg_colour,
        bg_alpha=0.3,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=140,
        radius=85,
        thickness=4,
        start_angle=180,
        end_angle=450,
        text_id=2
    },
    {
        name='platform',
        arg='coretemp.0/hwmon/hwmon4 temp 4',
        max=110,
        bg_colour=bg_colour,
        bg_alpha=0.5,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=140,
        radius=100,
        thickness=4,
        start_angle=0,
        end_angle=270,
        text_id=3
    },

    {
        name='platform',
        arg='coretemp.0/hwmon/hwmon4 temp 5',
        max=110,
        bg_colour=bg_colour,
        bg_alpha=0.5,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=370,
        radius=91,
        thickness=4,
        start_angle=180,
        end_angle=450,
        text_id=4
    },
    {
        name='platform',
        arg='coretemp.0/hwmon/hwmon4 temp 6',
        max=110,
        bg_colour=bg_colour,
        bg_alpha=0.3,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=370,
        radius=85,
        thickness=4,
        start_angle=180,
        end_angle=450,
        text_id=5
    },
    {
        name='platform',
        arg='coretemp.0/hwmon/hwmon4 temp 7',
        max=110,
        bg_colour=bg_colour,
        bg_alpha=0.5,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=370,
        radius=100,
        thickness=4,
        start_angle=0,
        end_angle=270,
        text_id=6
    },

    -- ram usage
    {
        name='memperc',
        arg='',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.5,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=600,
        radius=91,
        thickness=4,
        start_angle=180,
        end_angle=450,
        text_id=7
    },

    -- cpu temp, gpu temp, battery % and swap
    {
        name='platform',
        arg='coretemp.0/hwmon/hwmon4 temp 1',
        max=110,
        bg_colour=bg_colour,
        bg_alpha=0.3,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=140,
        radius=106,
        thickness=4,
        start_angle=0,
        end_angle=270,
        text_id=8
    },
    {
        name='nvidia',
        arg='temp',
        max=110,
        bg_colour=bg_colour,
        bg_alpha=0.3,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=370,
        radius=106,
        thickness=4,
        start_angle=0,
        end_angle=270,
        text_id=9
    },
    {
        name='swapperc',
        arg='',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.5,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=600,
        radius=100,
        thickness=4,
        start_angle=0,
        end_angle=270,
        text_id=10
    },
    {
        name='battery_percent',
        arg='',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.3,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=600,
        radius=106,
        thickness=4,
        start_angle=0,
        end_angle=270,
        text_id=11
    },

    -- storage usage
    {
        name='fs_used_perc',
        arg='/',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.5,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=600,
        radius=66,
        warn_level=95,
        crit_level=98,
        thickness=15.0,
        start_angle=0,
        end_angle=134.5,
        text_id=12
    },
    {
        name='fs_used_perc',
        arg='/home',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.5,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=600,
        radius=66,
        thickness=15.0,
        start_angle=135.5,
        end_angle=270,
        text_id=13
    },
    {
        name='fs_used_perc',
        arg='/media/linux',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.4,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=600,
        radius=50,
        thickness=14.5,
        start_angle=0,
        end_angle=134.5,
        text_id=14
    },
    {
        name='fs_used_perc',
        arg='/media/shared',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.4,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=600,
        radius=50,
        thickness=14.5,
        start_angle=135.5,
        end_angle=270,
        text_id=15
    },

    -- clock
    {
        name='time',
        arg='%H',
        max=12,
        bg_colour=bg_colour,
        bg_alpha=0.1,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=600,
        radius=20.0,
        thickness=4,
        start_angle=0,
        end_angle=360,
        text_id=16
    },
    {
        name='time',
        arg='%M',
        max=59,
        bg_colour=bg_colour,
        bg_alpha=0.2,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=600,
        radius=24.5,
        thickness=3,
        start_angle=0,
        end_angle=360,
        text_id=17
    },
    {
        name='time',
        arg='%S',
        max=59,
        bg_colour=bg_colour,
        bg_alpha=0.3,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=600,
        radius=28.5,
        thickness=2,
        start_angle=0,
        end_angle=360,
        text_id=18
    },

    -- cpu usage (text height=16, ring total height=230)
    {
        name='cpu',
        arg='cpu1',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.5,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=140,
        radius=66,
        thickness=15,
        start_angle=0,
        end_angle=90,
        text_id=19
    },
    {
        name='cpu',
        arg='cpu2',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.4,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=140,
        radius=50,
        thickness=14.5,
        start_angle=0,
        end_angle=90,
        text_id=20
    },
    {
        name='cpu',
        arg='cpu3',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.3,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=140,
        radius=34.5,
        thickness=14.0,
        start_angle=0,
        end_angle=90,
        text_id=21
    },

    {
        name='cpu',
        arg='cpu4',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.3,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=140,
        radius=34.5,
        thickness=14,
        start_angle=180,
        end_angle=270,
        text_id=22
    },
    {
        name='cpu',
        arg='cpu5',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.4,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=140,
        radius=50,
        thickness=14.5,
        start_angle=180,
        end_angle=270,
        text_id=23
    },
    {
        name='cpu',
        arg='cpu6',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.5,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=140,
        radius=66,
        thickness=15,
        start_angle=180,
        end_angle=270,
        text_id=24
    },
    
    {
        name='cpu',
        arg='cpu7',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.5,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=370,
        radius=66,
        thickness=15,
        start_angle=0,
        end_angle=90,
        text_id=25
    },
    {
        name='cpu',
        arg='cpu8',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.4,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=370,
        radius=50,
        thickness=14.5,
        start_angle=0,
        end_angle=90,
        text_id=26
    },
    {
        name='cpu',
        arg='cpu9',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.3,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=370,
        radius=34.5,
        thickness=14,
        start_angle=0,
        end_angle=90,
        text_id=27
    },

    {
        name='cpu',
        arg='cpu10',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.3,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=370,
        radius=34.5,
        thickness=14,
        start_angle=180,
        end_angle=270,
        text_id=28
    },
    {
        name='cpu',
        arg='cpu11',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.4,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=370,
        radius=50,
        thickness=14.5,
        start_angle=180,
        end_angle=270,
        text_id=29
    },
    {
        name='cpu',
        arg='cpu12',
        max=100,
        bg_colour=bg_colour,
        bg_alpha=0.5,
        fg_colour=0x3458eb,
        fg_alpha=1.0,
        x=140, y=370,
        radius=66,
        thickness=15,
        start_angle=180,
        end_angle=270,
        text_id=30
    }
}


require 'cairo'


-- global helper functions
function rgb_to_r_g_b(colour, alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end


function to_boolean(p_str)
    if p_str == "true" or p_str == "True" then
        return true
    elseif p_str == "false" or p_str == "False" then
        return false
    else
        return false
    end
end


function conky_ring_stats(cr)
    --[[
    IMPORTANT NOTES:
        regarding lua local function, it needs to be in sequence, caller needs to be at the bottom
        otherwise we'll get an error like below example:
            conky: llua_do_call: 
            function conky_main execution failed: /home/dirn/.config/conky/hybrid/lua/hybrid-rings.lua:555: 
            attempt to call a nil value (global 'setup_fs_text')
    ]]


    local function write_circle_char(cr, display_char, tset, degrads, deg, ival)
        local interval = (degrads * (tset.s_angle + (deg * (ival - 1)))) + tset.l_position
        local interval2 = degrads * (tset.s_angle + (deg * (ival - 1)))
        local txs = 0 + tset.text_radius * (math.sin(interval))
        local tys = 0 - tset.text_radius * (math.cos(interval))

        cairo_move_to (cr, txs + tset.x, tys + tset.y);
        cairo_rotate (cr, interval2)
        
        cairo_show_text (cr, display_char)
        cairo_rotate (cr, -interval2)
    end


    local function setup_circle_text(cr, display_text, tset)
        -- display_text = "hello world!"
        -- radi, horiz, verti, tcolor, talpha, start, finish, var1 = 63, 140, 140, 0xffffff, 1, 0, 70, 0

        local ival, has_celsius, sub_text = 1, false, display_text;
        local inum = string.len(display_text)
        range = tset.e_angle
        deg = (tset.e_angle - tset.s_angle) / (inum - 1)
        degrads = 1 * (math.pi / 180)

        if string.match(display_text, "°C") then
            has_celsius = true
            sub_text = string.gsub(display_text, "°C", "")
            inum = string.len(sub_text)
            -- print(sub_text)
        end

        for s_char in string.gmatch(sub_text, "(.)") do
            write_circle_char(cr, s_char, tset, degrads, deg, ival)
            ival = ival + 1
            -- print(ival, inum, s_char)

            -- special handling for °C character
            if ival > inum and has_celsius then
                write_circle_char(cr, "°C", tset, degrads, deg, ival)
            end
        end
    end


    local function setup_fs_text(cr, tset, value)
        local str = string.format( "%s %s", tset.text, value ) .. '%'
        
        setup_circle_text(cr, str, tset)
    end


    local function setup_nvidia_text(cr, tset, value)
        local nvidia_used = to_boolean(conky_parse("${if_match \"${nvidia temp}\" != \"\"}true${else}false${endif}"))
        local str = ''

        if nvidia_used then
            str = string.format( "%s %s", tset.text, value ) .. "°C"
        else
            str = "N/A"
        end

        cairo_move_to (cr, tset.x, tset.y)
        cairo_show_text (cr, str)
    end


    local function setup_cpu_text(cr, tset, value)
        local str = ''
        local thread_num = tonumber(tset.text)

        str = string.format( "%02d", tset.text )
        cairo_move_to (cr, tset.x, tset.y)
        cairo_show_text (cr, str)

        str = string.format( "%s", value ) .. '%'
        cairo_move_to (cr, tset.x + 17, tset.y)
        cairo_show_text (cr, str)
    end


    local function setup_other_text(cr, pt, tset, value)
        local str = ''

        if pt.name == 'platform' then
            str = string.format( "%s %d", tset.text, value ) .. "°C"
        elseif pt.name == 'time' then
            str = string.format( "%02d", value )
        else
            str = string.format( "%s %d", tset.text, value ) .. "%"
        end

        cairo_move_to (cr, tset.x, tset.y)
        cairo_show_text (cr, str)
    end


    local function setup_text(level_pct, cr, value, pt, tset)
        local font_name = 'Comfortaa SemiBold'
        local font_colour = g_main_colour
        local font_size = 11
        local str = ''
        local warn_level = 80
        local crit_level = 90

        if level_pct < warn_level then
            pt.fg_colour = time_circle_color
        elseif level_pct >= warn_level and level_pct < crit_level then
                pt.fg_colour = warn
                font_colour = warn_text
        else
            if pt.name == 'battery_percent' then
                pt.font_colour = g_main_colour
            else
                pt.fg_colour = crit
                font_colour = warn_text
            end
        end

        if pt.name == 'fs_used_perc' then
            font_colour = warn_text
        end

        cairo_set_source_rgb(cr,rgb_to_r_g_b(font_colour))
    
        cairo_select_font_face (cr, font_name, CAIRO_FONT_SLANT_BOLD, CAIRO_FONT_WEIGHT_NORMAL)
        cairo_set_font_size (cr, font_size)

        if pt.name == 'fs_used_perc' then
            setup_fs_text(cr, tset, value)
        elseif pt.name == 'nvidia' then
            setup_nvidia_text(cr, tset, value)
        elseif pt.name == 'cpu' then
            setup_cpu_text(cr, tset, value)
        else
            setup_other_text(cr, pt, tset, value)
        end
    
        cairo_fill_preserve (cr)
        cairo_stroke (cr)
        cairo_fill (cr)
    end


    local function draw_ring(cr, t, pt)
        local w, h = conky_window.width, conky_window.height

        local xc, yc, ring_r, ring_w, sa, ea = pt.x, pt.y, pt.radius, pt.thickness, pt.start_angle, pt.end_angle
        local bgc, bga, fgc, fga = pt.bg_colour, pt.bg_alpha, pt.fg_colour, pt.fg_alpha
    
        local angle_0 = sa * (2 * math.pi / 360) - math.pi / 2
        local angle_f = ea * (2 * math.pi / 360) - math.pi / 2
        local t_arc = t * (angle_f - angle_0)
    
        -- Draw background ring
    
        cairo_arc(cr, xc, yc, ring_r, angle_0, angle_f)
        cairo_set_source_rgba(cr, rgb_to_r_g_b(bgc, bga))
        cairo_set_line_width(cr, ring_w)
        cairo_stroke(cr)
        
        -- Draw indicator ring
    
        cairo_arc(cr, xc, yc, ring_r, angle_0, angle_0 + t_arc)
        cairo_set_source_rgba(cr, rgb_to_r_g_b(fgc, fga))
        cairo_stroke(cr)		
    end


    local function level_watch(level_pct, pt)
        local warn_level = 0
        local crit_level = 0

        if pt.name == 'battery_percent' then
            warn_level = 30
            crit_level = 20
    
            if level_pct > warn_level then
                pt.fg_colour = battery_circle_color
            elseif level_pct <= warn_level and level_pct > crit_level then
                pt.fg_colour = warn
            else
                pt.fg_colour = crit
            end
        elseif pt.name ~= 'time' then
            warn_level = 80
            crit_level = 92
            if level_pct < warn_level then
                if pt.name == 'memperc' or pt.name == 'fs_used_perc' then
                    pt.fg_colour = ram_circle_color
                else
                    pt.fg_colour = normal
                end
            elseif level_pct >= warn_level and level_pct < crit_level then
                pt.fg_colour = warn
            else
                pt.fg_colour = crit
            end
        end
    end


	local function setup_rings(cr, pt)
		local str = ''
		local value = 0

        str = string.format('${%s %s}', pt.name, pt.arg)
        str = conky_parse(str)
        
        value = tonumber(str)
        display_value = value

        if pt.name == 'time' and pt.arg == '%H' and value >= 12 then
            value = value - 12
        end

		if value == nil then value = 0 end
        local pct = value / pt.max
        local level_watch_pct = pct * 100

        -- level watch should check percentage, not value
        level_watch(level_watch_pct, pt)
        draw_ring(cr, pct, pt)
        
        local tset = text_settings[pt.text_id]
        if tset == nil then return end

        if tset.show then
            setup_text(level_watch_pct, cr, display_value, pt, tset)
        end
    end


	local updates=conky_parse('${updates}')
	update_num = tonumber(updates)

	if update_num > update_num_min then
	    for i in pairs(settings_table) do
            setup_rings(cr, settings_table[i])
	    end
    end
end


-- array start from index 1
text_settings = {
    -- cpu core
    { text = 'C01', show = true, x = 30, y = 40, ind_id = 1 },
    { text = 'C02', show = true, x = 30, y = 56, ind_id = 2 },
    { text = 'C03', show = true, x = 230, y = 234, ind_id = 3 },
    { text = 'C04', show = true, x = 30, y = 270, ind_id = 4 },
    { text = 'C05', show = true, x = 30, y = 286, ind_id = 5 },
    { text = 'C06', show = true, x = 230, y = 464, ind_id = 6 },

    -- ram
    { text = 'RAM', show = true, x = 30, y = 500, ind_id = 7 },

    -- cpu, gpu, bat and swap
    { text = 'CPU', show = true, x = 230, y = 250, ind_id = 8 },
    { text = 'GPU', show = true, x = 230, y = 480, ind_id = 9 },
    { text = 'SWP', show = true, x = 230, y = 694, ind_id = 10 },
    { text = 'BAT', show = true, x = 230, y = 710, ind_id = 11 },

    -- disk storage
    { text = '/', show = true, text_radius = 62, x = 140, y = 600, s_angle = 5, e_angle = 30, l_position = 0 },
    { text = 'Home', show = true, text_radius = 62, x = 140, y = 600, s_angle = 140, e_angle = 195, l_position = 0 },
    { text = 'Linux', show = true, text_radius = 46, x = 140, y = 600, s_angle = 5, e_angle = 70, l_position = 0 },
    { text = 'Shared', show = true, text_radius = 46, x = 140, y = 600, s_angle = 140, e_angle = 230, l_position = 0 },

    -- clock
    { text = 'HH', show = true, x = 126, y = 604 },
    { text = 'MM', show = true, x = 142, y = 604 },
    { text = 'SS', show = false, x = 152, y = 604 },

    -- cpu threads
    { text = '1', show = true, x = 125, y = 78 },
    { text = '2', show = true, x = 125, y = 94 },
    { text = '3', show = true, x = 125, y = 110 },

    { text = '4', show = true, x = 125, y = 178 },
    { text = '5', show = true, x = 125, y = 194 },
    { text = '6', show = true, x = 125, y = 210 },
    
    { text = '7', show = true, x = 125, y = 308 },
    { text = '8', show = true, x = 125, y = 324 },
    { text = '9', show = true, x = 125, y = 340 },
    
    { text = '10', show = true, x = 125, y = 408 },
    { text = '11', show = true, x = 125, y = 424 },
    { text = '12', show = true, x = 125, y = 440 },
}


text_indicator = {
    { x1 = 75, y1 = 35, x2 = 115, y2 = 35, x3 = 128, y3 = 48, alpha = 0.9 },        -- c1
    { x1 = 75, y1 = 51, x2 = 85, y2 = 51, x3 = 97, y3 = 64, alpha = 0.9 },          -- c2
    { x1 = 204, y1 = 219, x2 = 216, y2 = 231, x3 = 226, y3 = 231, alpha = 0.9 },    -- c3
    
    { x1 = 75, y1 = 265, x2 = 115, y2 = 265, x3 = 128, y3 = 278, alpha = 0.9 },     -- c4
    { x1 = 75, y1 = 281, x2 = 85, y2 = 281, x3 = 97, y3 = 294, alpha = 0.9 },       -- c5
    { x1 = 204, y1 = 449, x2 = 216, y2 = 461, x3 = 226, y3 = 461, alpha = 0.9 },    -- c6
    
    { x1 = 80, y1 = 495, x2 = 115, y2 = 495, x3 = 128, y3 = 508, alpha = 0.9 },     -- ram

    { x1 = 182, y1 = 239, x2 = 190, y2 = 247, x3 = 226, y3 = 247, alpha = 0.9 },    -- cpu
    { x1 = 182, y1 = 469, x2 = 190, y2 = 477, x3 = 226, y3 = 477, alpha = 0.9 },    -- gpu
    { x1 = 204, y1 = 679, x2 = 216, y2 = 691, x3 = 226, y3 = 691, alpha = 0.9 },    -- swap
    { x1 = 182, y1 = 699, x2 = 190, y2 = 707, x3 = 226, y3 = 707, alpha = 0.9 }     -- bat
}


line_settings = {
    -- vertical
    { x1 = 30, y1 = 0, x2 = 30, y2 = 750 },
    { x1 = 140, y1 = 0, x2 = 140, y2 = 750 },
    { x1 = 250, y1 = 0, x2 = 250, y2 = 750 },
    { x1 = 275, y1 = 0, x2 = 275, y2 = 750 },

    -- horizontal
    { x1 = 0, y1 = 30, x2 = 470, y2 = 30 },
    -- { x1 = 0, y1 = 140, x2 = 270, y2 = 140 },
    { x1 = 0, y1 = 250, x2 = 270, y2 = 250 },
    { x1 = 0, y1 = 260, x2 = 270, y2 = 260 },
    -- { x1 = 0, y1 = 370, x2 = 270, y2 = 370 },
    { x1 = 0, y1 = 480, x2 = 270, y2 = 480 },
    { x1 = 0, y1 = 490, x2 = 270, y2 = 490 },
    { x1 = 0, y1 = 600, x2 = 270, y2 = 600 },
    { x1 = 0, y1 = 710, x2 = 270, y2 = 710 },

    -- diagonal
    { x1 = 0, y1 = 0, x2 = 290, y2 = 290 },
    { x1 = 0, y1 = 230, x2 = 290, y2 = 520 },
    { x1 = 0, y1 = 460, x2 = 290, y2 = 750 },
}


circle_settings = {
    { x = 230, y = 50, radius = 18.0, start_angle = 0.0, end_angle = 360.0 },
    { x = 50, y = 230, radius = 18.0, start_angle = 0.0, end_angle = 360.0 },
    { x = 230, y = 280, radius = 18.0, start_angle = 0.0, end_angle = 360.0 },
    { x = 50, y = 460, radius = 18.0, start_angle = 0.0, end_angle = 360.0 },
    { x = 230, y = 510, radius = 18.0, start_angle = 0.0, end_angle = 360.0 },
    { x = 50, y = 690, radius = 18.0, start_angle = 0.0, end_angle = 360.0 },

    { x = 30, y = 255, radius = 50.0, start_angle = 0.0, end_angle = 360.0 },
    { x = 250, y = 255, radius = 50.0, start_angle = 0.0, end_angle = 360.0 },
    { x = 30, y = 485, radius = 50.0, start_angle = 0.0, end_angle = 360.0 },
    { x = 250, y = 485, radius = 50.0, start_angle = 0.0, end_angle = 360.0 },

    { x = 140, y = 140, radius = 75.0, start_angle = 0.0, end_angle = 360.0 },
    { x = 140, y = 370, radius = 75.0, start_angle = 0.0, end_angle = 360.0 },
    { x = 140, y = 600, radius = 75.0, start_angle = 0.0, end_angle = 360.0 },

    -- { x = 140, y = 140, radius = 25.0, start_angle = 0.0, end_angle = 360.0 },
    -- { x = 140, y = 370, radius = 25.0, start_angle = 0.0, end_angle = 360.0 },
    -- { x = 140, y = 600, radius = 11.0, start_angle = 0.0, end_angle = 360.0 },
}


function draw_elements(line_sketches_toggle)
    local function draw_text_indicator(cr)
        local line_colour, line_thick = g_main_colour, 0.5
        
        for x in pairs(text_settings) do
            -- the usage of continue and ::continue:: is
            -- not backward compatible with lua older version.

            local text_item = text_settings[x]
            
            if text_item ~= nil and text_item.ind_id ~= nil then
                local i_item = text_indicator[text_item.ind_id]
    
                if i_item ~= nil then
                    cairo_set_source_rgba(cr, rgb_to_r_g_b(line_colour, i_item.alpha))
                    cairo_set_line_width(cr, line_thick)
            
                    cairo_move_to (cr, i_item.x1, i_item.y1)
                    cairo_line_to (cr, i_item.x2, i_item.y2)
                    cairo_line_to (cr, i_item.x3, i_item.y3)
                    cairo_stroke (cr)
                end
            end
        end
    end
    
    
    local function draw_lines(cr)
        for x in pairs(line_settings) do
            local l_item = line_settings[x]
            
            cairo_move_to (cr, l_item.x1, l_item.y1)
            cairo_line_to (cr, l_item.x2, l_item.y2)
            cairo_stroke (cr)
        end
    end
    
    
    local function draw_circles(cr)
        -- xc = 250.0
        -- yc = 255.0
        -- radius = 50.0
        -- angle1 = 0.0  * (2 * math.pi / 360) - math.pi / 2
        -- angle2 = 360.0 * (2 * math.pi / 360) - math.pi / 2
    
        for x in pairs(circle_settings) do
            local c_item = circle_settings[x]
            
            local angle_s = c_item.start_angle * (2 * math.pi / 360) - math.pi / 2
            local angle_e = c_item.end_angle * (2 * math.pi / 360) - math.pi / 2
    
            cairo_arc (cr, c_item.x, c_item.y, c_item.radius, angle_s, angle_e)
            cairo_stroke (cr)
        end
    end
    
    
    local function draw_line_sketches(cr, line_sketches_toggle)
        if to_boolean(line_sketches_toggle) == false then 
            return
        end
    
        local line_colour, line_alpha, line_thick = g_main_colour, 0.15, 1.0
    
        cairo_set_source_rgba(cr, rgb_to_r_g_b(line_colour, line_alpha))
        cairo_set_line_width(cr, line_thick)
        
        draw_lines(cr)
        draw_circles(cr)
    end
    
    
    local function draw_logo(cr)
        local w, h = 0, 0
        local imagefile = "/home/ahmed/.config/awesome/themes/conky/hybrid/images/distro-3a.png"
        local image = cairo_image_surface_create_from_png (imagefile)
    
        w = cairo_image_surface_get_width (image)
        h = cairo_image_surface_get_height (image)
    
        cairo_translate (cr, 495.0, 32.0)
        -- cairo_rotate (cr, 45* math.pi/180)
        cairo_scale  (cr, 40.0/w, 40.0/h)
        -- cairo_translate (cr, -0.5*w, -0.5*h)
    
        cairo_set_source_surface (cr, image, 0, 0)
        cairo_paint (cr)
        cairo_surface_destroy (image)
    end


    if conky_window == nil then return end

    local cs = cairo_xlib_surface_create(conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height)
    local cr = cairo_create(cs)

    draw_line_sketches(cr, line_sketches_toggle)
    draw_text_indicator(cr)
    conky_ring_stats(cr)
    draw_logo(cr)           -- logo needs to be render last due to cairo_set_source_surface

    cairo_surface_destroy(cs)
    cairo_destroy(cr)
end


function conky_main(line_sketches_toggle)
    draw_elements(line_sketches_toggle)
end
