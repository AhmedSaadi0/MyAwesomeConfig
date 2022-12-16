local helpers = {}

function helpers.create_gradient_color(args)
    local type = args.type or "linear"
    
    local from = args.from or {0, 0}
    local to = args.to or {0, 200}

    local color1 = args.color1 or "#7766fb"
    local color2 = args.color2 or "#fe67a9"

    local stops1 = args.stops1 or 0
    local stops2 = args.stops2 or 1

    local stops = args.stops or {{stops1, color1}, {stops2, color2}}

    return {
        type = type,
        from = from,
        to = to,
        stops = stops
    }
end

return helpers
