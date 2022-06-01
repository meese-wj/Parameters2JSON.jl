# Parameters2JSON

This is a `Julia` package turns `struct` parameters into `JSON` files (and back) with the [JSON3 package](https://github.com/quinnj/JSON3.jl) as well as the [StructTypes package](https://github.com/JuliaData/StructTypes.jl/tree/master). 

**Note:** The `StructTypes` package must be explicitly `Pkg.add`ed to the current Julia environment, but it does not need to be explicitly `import`ed to use the `@jsonable` macro.

## Example Usage

We recommend using the `@jsonable` macro when defining new structs. For example, given a new parameter struct, denoted by `Params`, we would write something of the following form:

```julia
# ===================== #
# If StructTypes is not already added to the environment.
import Pkg
Pkg.add("StructTypes")
# ===================== #

# Example usage below.
using Parameters2JSON

@jsonable struct Params
    ... < parameter fields live here > ...
end
```

By using the `@jsonable` macro, one does not need to forward-define the `StructTypes.StructType` functionality. The equivalent Julia code as that above is the following:

```julia
import StructTypes
struct Params
    ... < parameter fields live here > ...
end
StructTypes.StructType(::Type{Params}) = StructTypes.Struct()
```

After the parameter structs have been defined, then the `JSON3` API can be used to read and write structs in JSON format.