using ControllerIO
# This is an example for the DCDC-converter example of Dionysos

# Path to exported controller data
filename = "examples//concrete_controller"

## Optionnaly check the loaded data from CSV files
# origin, h, pos2state, state2input, input2u = ControllerIO.LoadData.load_controller_data_csv(filename)

# Load the concrete controller function from CSV
concrete_controller = ControllerIO.ControllerFunction.get_controller_function(filename)

# Test points
test_points = [
    [1.2, 5.6],  # in domain
    [1.4, 5.7], # in domain
    [1.2, 5.48], # in domain but uncontrollable
    [100.0, 100.0],  # out of domain
]

# Apply the controller to each point
for x in test_points
    u = concrete_controller(x)
    println("x = $x → u = $u")
end
