module Parameters2JSON

using JSON3
using StructTypes

export @jsonable, StructType, Struct
export import_json, export_json, pretty_display, import_json_and_display

"""
    @jsonable [mutable] struct Foo ... end

Convenience macro allowing JSON import, exports, and displays for structs.

# Additional Information
One __must__ have the [StructTypes](https://github.com/JuliaData/StructTypes.jl/tree/master) package
`Pkg.add`ed in order to use any JSON functionality.
"""
macro jsonable(expr)
    # Only allow operations for mutable and immutable structs
    expr.head == :struct ? nothing : throw(ArgumentError("JSONable macro must be used on structs."))
    # Determine the type of struct
    struct_name = expr.args[ findall( x -> typeof(x) == Symbol, expr.args )[1] ]
    # Define the StructType function from StructTypes for use in JSON3 functions
    return esc(quote
        import StructTypes
        $expr 
        StructTypes.StructType(::Type{$struct_name}) = StructTypes.Struct() 
    end)
end


function import_json(fl, ::Type{T}) where {T}
    return JSON3.read( read(fl, String), T )
end

function export_json(mystruct, fl; openmode="w")
    open(fl, openmode) do io 
        JSON3.pretty(io, mystruct)
    end
    nothing
end

function pretty_display(io::IO, params)
    println(io, "\nValues for $(typeof(params)):")
    JSON3.pretty(io, params)
    println(io, "\n")
    return nothing 
end

pretty_display(params) = pretty_display(stdout, params)

function import_json_and_display(fl, ::Type{T}, io::IO = stdout) where {T}
    println("\nImporting values from $fl...")
    params = import_json(fl, T)
    pretty_display(io, params)
    return params
end

end
