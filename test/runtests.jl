using Parameters2JSON
using Test



@testset "Parameters2JSON.jl" begin
    # Test a basic jsonable struct
    @test let
        @jsonable struct BasicParam
            x
        end
        inside = "I'm a test"
        output_string = "\nValues for BasicParam:\n{\n   \"x\": \"$inside\"\n}\n\n"
        output_string == pretty_display(String, BasicParam(inside))       
    end

    # Test a parametric jsonable struct
    @test let
        @jsonable struct ParametricParam{T <: Int}
            x::T
        end
        display_type = Int64
        inside = 42
        output_string = "\nValues for ParametricParam{Int64}:\n{\n   \"x\": $inside\n}\n\n"
        output_string == pretty_display(String, ParametricParam(inside))
    end

    # Test a struct that lives in a type hierarchy
    @test let
        @jsonable struct SubtypeParam <: Number
            real_part::Int
            imag_part::Float64
        end
        inside_real = 42
        inside_imag = -42 # Converts the Float64 to an Int64 for string purposes I guess
        output_string = "\nValues for SubtypeParam:\n{\n   \"real_part\": $inside_real,\n   \"imag_part\": $inside_imag\n}\n\n"
        output_string == pretty_display(String, SubtypeParam(inside_real, inside_imag))
    end

    # Add a test for subtypes and parameteric types
    @test let
        @jsonable struct SubtypeParametricParam{T <: Number} <: Number
            real_part::T
            imag_part::T
        end
        display_type = Int64
        inside_real = 42.0
        inside_imag = -42.0
        output_string = "\nValues for SubtypeParametricParam{$(typeof(inside_real))}:\n{\n   \"real_part\": $(convert(display_type, inside_real)),\n   \"imag_part\": $(convert(display_type, inside_imag))\n}\n\n"
        output_string == pretty_display(String, SubtypeParametricParam(inside_real, inside_imag))
    end

    # TODO: Add more tests?
    # TODO: Allow for variadic parametric types?
end
