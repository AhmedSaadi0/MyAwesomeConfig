local helpers = {}

function helpers.create_gradient_color(args)
    local type = args.type or "linear"
    local from = args.from or {0, 0}
    local top = args.top or {200, 0}
    local stops = args.stops or {{0, "#7766fb"}, {1, "#fe67a9"}}

    return {
        type = type,
        from = from,
        to = top,
        stops = stops
    }
end

return helpers
