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
        inside = 42
        output_string = "\nValues for ParametricParam{Int64}:\n{\n   \"x\": $inside\n}\n\n"
        output_string == pretty_display(String, ParametricParam(inside))
    end
end
