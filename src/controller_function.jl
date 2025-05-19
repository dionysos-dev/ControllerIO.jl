module ControllerFunction

import StaticArrays: SVector, SMatrix

using ..LoadData
LD = LoadData

function get_controller_function(filename::String)
    origin, h, pos2state, state2input, input2u = LD.load_controller_data_csv(filename)
    return get_controller_function(origin, h, pos2state, state2input, input2u)
end

function get_controller_function(origin, h, pos2state, state2input, input2u)
    function concrete_controller(x)
        # Compute grid position
        xpos = round.(Int, (x .- origin) ./ h)

        # Lookup abstract state
        if !haskey(pos2state, xpos)
            @warn "State out of domain" x
            return nothing
        end
        state = pos2state[xpos]

        # Lookup abstract input
        if !haskey(state2input, state) || state2input[state] == -1
            @warn "Uncontrollable state" x
            return nothing
        end
        input = state2input[state]

        # Lookup concrete input
        if !haskey(input2u, input)
            @warn "No concrete input found for abstract input" input
            return nothing
        end
        u = input2u[input]

        return u
    end

    return concrete_controller
end



end
