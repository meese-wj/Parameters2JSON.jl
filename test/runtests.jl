using Parameters2JSON
using Test

@testset "Parameters2JSON.jl" begin
    @test begin
        @jsonable struct TestParams
            x
        end
        inside = "I'm a test"
        output_string = """

        Values for TestParams:
        {
           "x": "$(inside)"
        }

        """
        test_io = IOBuffer()
        pretty_display( test_io, TestParams(inside) )
        output_string == String(take!(test_io))        
    end
end
