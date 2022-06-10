using Parameters2JSON
using Test



@testset "Parameters2JSON.jl" begin
    # Test a basic @jsonable struct
    @test begin
        @jsonable struct TestParams
            x
        end
        inside = "I'm a test"
        output_string = "\nValues for TestParams:\n{\n   \"x\": \"$inside\"\n}\n\n"
        output_string == pretty_display(String, TestParams(inside))       
    end
end
