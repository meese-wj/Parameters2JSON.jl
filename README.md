# Parameters2JSON

This is a `Julia` package turns `struct` parameters into `JSON` files (and back) with the [JSON3 package](https://github.com/quinnj/JSON3.jl) as well as the [StructTypes package](https://github.com/JuliaData/StructTypes.jl/tree/master).

## Example Usage

To use this package with a new parameter struct, denoted by `Params`, we would write something of the following form:

```julia
using Parameters2JSON

# Define the struct with some fields.
struct Params
    ... < parameter fields live here > ...
end

# This line must be included for JSON3 to understand the `Params` trait.
Parameters2JSON.StructType(::Type{Params}) = Struct()
```
