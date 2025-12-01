using ControllerIO
# This is an example for the Robot example of Dionysos

# Path to exported controller data
filename = "examples//Robot//concrete_controller"

# Load the concrete controller function from CSV
concrete_controller = ControllerIO.ControllerFunction.get_controller_function(filename)

# Test points
test_points = [
    [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], # In domain
    [0.2, 0.2, 0.2, 0.2, 0.2, 0.2], # In domain
    [-1.0, 0.5, 0.5, 0.5, 0.5, 0.5], # Uncontrollable
    [-3.0, 0.5, 0.5, 0.5, 0.5, 0.5], # Out of domain
]

# Apply the controller to each point
for x in test_points
    u = concrete_controller(x)
    println("x = $x → u = $u")
end

origin, h, pos2state, state2input, input2u = ControllerIO.LoadController.load_controller_data_csv(filename)

# Default: plot over dimensions 1 and 2
ControllerIO.VisualizeController.plot_controller_grid(origin, h, pos2state, state2input; dims = [1, 2])