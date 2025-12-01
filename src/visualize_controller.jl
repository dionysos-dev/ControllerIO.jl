
module VisualizeController
using Plots

# Plot a 2D colored grid of abstract positions.
# - Only positions present as keys in `pos2state` are shown (the domain).
# - For each position, we check if there is a control: `haskey(state2input, state)`.
#   * Green ■ : there IS a control for (at least one) state at that projected position
#   * Red   □ : NO control for any state at that projected position
function plot_controller_grid(origin, h, pos2state::Dict, state2input::Dict; dims = [1, 2])
    d1, d2 = dims

    # 1. Aggregate by projected cell (i1, i2) → has_control::Bool
    cells = Dict{Tuple{Int,Int}, Bool}()

    for (pos, state) in pos2state
        length(pos) >= max(d1, d2) || error("Position has dim $(length(pos)), but dims = $dims")

        i1 = pos[d1]
        i2 = pos[d2]
        has_ctrl = haskey(state2input, state)

        key = (i1, i2)
        if haskey(cells, key)
            cells[key] = cells[key] || has_ctrl
        else
            cells[key] = has_ctrl
        end
    end

    isempty(cells) && (println("No cells to plot."); return)

    # 2. Build rectangle polygons (once per projected cell)
    xs_with    = Vector{Vector{Float64}}()
    ys_with    = Vector{Vector{Float64}}()
    xs_without = Vector{Vector{Float64}}()
    ys_without = Vector{Vector{Float64}}()

    for ((i1, i2), has_ctrl) in cells
        if origin === nothing || h === nothing
            # index-space rectangles
            x1 = i1 - 0.5
            x2 = i1 + 0.5
            y1 = i2 - 0.5
            y2 = i2 + 0.5
        else
            # physical-space rectangles, consistent with get_rec / Grid
            x1 = origin[d1] + (i1 - 0.5) * h[d1]
            x2 = origin[d1] + (i1 + 0.5) * h[d1]
            y1 = origin[d2] + (i2 - 0.5) * h[d2]
            y2 = origin[d2] + (i2 + 0.5) * h[d2]
        end

        xs_rect = [x1, x2, x2, x1, x1]
        ys_rect = [y1, y1, y2, y2, y1]

        if has_ctrl
            push!(xs_with, xs_rect);    push!(ys_with, ys_rect)
        else
            push!(xs_without, xs_rect); push!(ys_without, ys_rect)
        end
    end

    # 3. Plot
    plt = plot(legend = :outerright, aspect_ratio = :equal)

    if !isempty(xs_without)
        plot!(plt, xs_without, ys_without;
              seriestype = :shape,
              fillalpha = 0.4,
              linealpha = 0.8,
              color = :red,
              label = false)
    end

    if !isempty(xs_with)
        plot!(plt, xs_with, ys_with;
              seriestype = :shape,
              fillalpha = 0.6,
              linealpha = 0.9,
              color = :green,
              label = false)
    end

    if origin === nothing || h === nothing
        xlabel!(plt, "index dim $d1")
        ylabel!(plt, "index dim $d2")
    else
        xlabel!(plt, "dim $d1")
        ylabel!(plt, "dim $d2")
    end

    title!(plt, "Controller domain (rectangles, dims = $(d1), $(d2))")

    return plt
end

end
