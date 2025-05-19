# ControllerIO.jl
A lightweight utility package for exporting and reloading concrete controllers computed with Dionysos.jl, without requiring the full Dionysos.jl library at runtime.

This Dionysos package provides:
- A function to serialize a concrete controller into a `.csv` file, including the necessary grid and lookup data.
This package provides:
- A standalone function to reconstruct the controller from the saved file, enabling control evaluation without any dependency on Dionysos.

Useful for deployment, testing, and lightweight integration in environments where symbolic abstractions are already computed.

Typical workflow:
1. Export the controller from Dionysos using `export_controller_csv(...)`.
2. Load it externally via `load_controller_data_csv(...)`, or `get_controller_function(...)` which returns a function `u(x)`.
