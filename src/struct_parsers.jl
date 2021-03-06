function _recurse_expr_for_symbol(ex)
    if !(ex.args[1] isa Symbol || ex.args[1] isa Expr)
        throw(ArgumentError("\n$ex argument is neither a Symbol or Expr. Avoiding recursion and breaking.\n"))
    end
    if ex.args[1] isa Symbol
        return ex.args[1]
    end
    _recurse_expr_for_symbol(ex.args[1])
end

_is_struct(expr) = expr.head === :struct ? nothing : throw(ArgumentError("\n\n$expr\n\nis not a struct expression."))

function _struct_name(expr)
    if expr.args[2] isa Symbol
        return expr.args[2]
    elseif expr.args[2] isa Expr
        return _recurse_expr_for_symbol(expr.args[2])
    end
    throw(ArgumentError("\n$expr argument is neither a Symbol nor an Expr.\n"))
end

function _is_parametric_struct(expr)
    # Case 1: Bare struct definition -- nothing fancy → false
    #   * To get through, expr.args[2] must be a Expr
    # Case 2: Subtype struct definition -- no parameters → false
    #   * To get through, expr cannot be a nonparametric subtype 
    # Case 3: Split into two cases 
    #   * 3.1: Single parameter has a :curly head → true  TODO: Allow for variadic parameters
    #   * 3.2: Subtype struct which then has a first-argument Expr → TODO: Does this break ever?
    return ( 
            !(expr.args[2] isa Symbol) # Case 1
            && !(expr.args[2].head === :<: && !(expr.args[2].args[1] isa Expr)) # Case 2
            && (expr.args[2].head === :curly || (expr.args[2].head === :<: && expr.args[2].args[1] isa Expr)) # Case 3
           )
end

function _parametric_struct_type(subexpr)
    if !(subexpr.head === :curly || subexpr.head === :<:)
        throw(ArgumentError("\n\n$subexpr\n\nargument is not a proper subexpression argument. Avoiding recursion.\n"))
    end

    if subexpr.head === :curly
        return subexpr.args[2].args[1]
    end
    _parametric_struct_type(subexpr.args[1])
end

function implement_structtypes(expr)
    name_expr = _struct_name(expr)
    ex = :( StructTypes.StructType(::Type{$(name_expr)}) = StructTypes.Struct() )
    if _is_parametric_struct(expr)
        template_var = _parametric_struct_type(expr.args[2])
        ex = :( StructTypes.StructType(::Type{$name_expr{$template_var}}) where {$template_var} = StructTypes.Struct() )
    end
    return ex
end

function _jsonable(expr)
    _is_struct(expr) # Throws an ArgumentError if the expr is not a struct expression
    st_name = _struct_name(expr)
    st_StrucType_fn = implement_structtypes(expr)
    return quote
        import StructTypes
        $expr
        $st_StrucType_fn
    end   
end