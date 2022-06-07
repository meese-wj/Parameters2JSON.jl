module Parameters2JSON

using JSON3
using StructTypes

export @jsonable, implement_structtypes, StructType, Struct, find_struct_Symbol, has_expr
export import_json, export_json, pretty_display, import_json_and_display

include("struct_parsers.jl")

"""
    @jsonable [mutable] struct Foo ... end

Convenience macro allowing JSON import, exports, and displays for structs.

# Additional Information
One __must__ have the [StructTypes](https://github.com/JuliaData/StructTypes.jl/tree/master) package
`Pkg.add`ed in order to use any JSON functionality.
"""
# macro jsonable(expr)
#     # Only allow operations for mutable and immutable structs
#     expr.head == :struct ? nothing : throw(ArgumentError("JSONable macro must be used on structs."))
#     # Determine the type of struct
#     # struct_name = expr.args[ findall( x -> typeof(x) == Symbol, expr.args )[1] ] # Breaks for templated structs 
#     struct_name = strip_struct_name( expr )
#     # Define the StructType function from StructTypes for use in JSON3 functions
#     structtype_expr = implement_structtypes(expr)
#     return esc(quote
#         import StructTypes
#         $expr 
#         # StructTypes.StructType(::Type{$struct_name}) = StructTypes.Struct() 
#         $structtype_expr
#     end)
# end

macro jsonable(expr)
    return esc(_jsonable(expr))
end
"""
    import_json(fl, ::Type{T})

Reads from a file `fl` into a `@jsonable` struct of type `T`.

# Additional Information
* Wrapper around `JSON3.read(::String, T )`.
"""
function import_json(fl, ::Type{T}) where {T}
    return JSON3.read( read(fl, String), T )
end

"""
    export_json(mystruct, fl; openmode="w")

Writes the `@jsonable` struct `mystruct` to a file `fl`.

# Additional Information
* Wrapper around `JSON3.pretty(::IO, mystruct)`.
"""
function export_json(mystruct, fl; openmode="w")
    open(fl, openmode) do io 
        JSON3.pretty(io, mystruct)
    end
    nothing
end

"""
    pretty_display(io::IO, params)

Writes the `@jsonable` struct `params` to an `IO` stream.

# Additional Information
* Further prettifies a call to `JSON3.pretty(::IO, params)`.
"""
function pretty_display(io::IO, params)
    println(io, "\nValues for $(typeof(params)):")
    JSON3.pretty(io, params)
    println(io, "\n")
    return nothing 
end

"""
    pretty_display(params)

Writes the `@jsonable` struct `params` to an `stdout`.

# Additional Information
* Further prettifies a call to `JSON3.pretty(stdout, params)`.
"""
pretty_display(params) = pretty_display(stdout, params)

"""
    import_json_and_display(fl, ::Type{T}, io::IO = stdout)

Reads from a file `fl` into a `@jsonable` struct of type `T` and calls `pretty_display` on the result.

# Additional Information
* I think I'll destroy this function and merge it into `import_json` as a different method.
"""
function import_json_and_display(fl, ::Type{T}, io::IO = stdout) where {T}
    println("\nImporting values from $fl...")
    params = import_json(fl, T)
    pretty_display(io, params)
    return params
end

end
