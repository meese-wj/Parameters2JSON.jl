const STRUCT_INDEX = 2

has_expr( args ) = length( findall( x -> typeof(x) == Expr, args ) ) > 0

has_curly( expr ) = typeof(expr) == Expr && expr.head == :curly
find_struct_Symbol( args ) = findall( x -> typeof(x) == Symbol, args )[1]
# function strip_struct_name( expr )
#     temp_expr = expr
#     if has_expr(temp_expr.args)
#         idx = findall( x -> typeof(x) == Expr, temp_expr.args )[1]  # Choose the first for the struct name
#         temp_expr = expr.args[idx]
#     end
#     return temp_expr.args[ find_struct_Symbol(temp_expr.args) ]
# end

function strip_struct_name(expr)
    if typeof(expr.args[STRUCT_INDEX]) == Expr
        return expr.args[STRUCT_INDEX].args[1]
    end
    return expr.args[STRUCT_INDEX]
end

function template_type_expr(struct_name_expr)
    return struct_name_expr.args[2].args[1]
end

function implement_structtypes(struct_expr)
    ex = :(1 + 2) # temporary
    name_expr = strip_struct_name(struct_expr)
    if typeof(struct_expr.args[STRUCT_INDEX]) == Symbol
        ex = :( StructTypes.StructType(::Type{$(name_expr)}) = StructTypes.Struct() )
    elseif typeof(struct_expr.args[STRUCT_INDEX]) == Expr
        template_var = template_type_expr( struct_expr.args[STRUCT_INDEX] )
        template_var
        name_expr = :( $name_expr{$template_var} )
        ex = :( StructTypes.StructType(::Type{$name_expr}) where {$template_var} = StructTypes.Struct() )
    end
    return ex 
end