using ControllerIO
# This is an example for the Robot example of Dionysos

# Path to exported controller data
filename = "examples//Robot//concrete_controller"

# Load the concrete controller function from CSV
concrete_controller = ControllerIO.ControllerFunction.get_controller_function(filename)

# Test points
test_points = [
    [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], # In domain
    [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5], # In domain
    [-1.0, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5], # Uncontrollable
    [-3.0, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5], # Out of domain
]

# Apply the controller to each point
for x in test_points
    u = concrete_controller(x)
    println("x = $x → u = $u")
end
