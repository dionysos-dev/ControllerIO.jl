
module LoadData
using DataFrames, CSV

function load_controller_data_csv(basename::String)
    println(basename * "_Grid.csv")
    grid_df = CSV.read(basename * "_Grid.csv", DataFrame; delim=';')
    state_df = CSV.read(basename * "_StateMap.csv", DataFrame; delim=';')
    ctrl_df = CSV.read(basename * "_ControllerMap.csv", DataFrame; delim=';')
    input_df = CSV.read(basename * "_InputMap.csv", DataFrame; delim=';')
    return parse_controller_tables(grid_df, state_df, ctrl_df, input_df)
end

function parse_controller_tables(grid_df, state_df, ctrl_df, input_df)
    origin = Vector{Float64}(grid_df[grid_df.key .== "origin", Not(:key)][1, :])
    h = Vector{Float64}(grid_df[grid_df.key .== "h", Not(:key)][1, :])

    pos2state = Dict{Vector{Int}, Int}()
    for row in eachrow(state_df)
        pos = [Float64(row[Symbol("x$i")]) for i in 1:(ncol(state_df)-1)]
        pos2state[pos] = row.abstract_state
    end

    state2input = Dict(ctrl_df.abstract_state .=> ctrl_df.abstract_input)

    input2u = Dict{Int, Vector{Float64}}()
    for row in eachrow(input_df)
        u = [Float64(row[Symbol("u$i")]) for i in 1:(ncol(input_df)-1)]
        input2u[row.abstract_input] = u
    end

    return origin, h, pos2state, state2input, input2u
end

end 