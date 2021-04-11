namespace QCHack.Part2 {
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Logical;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;



    //----------------------------------------------------------
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation TestDiagonalRooks () : Unit {
        let rooks = [(0,0), (1,1), (2,2)];
        let (row, col) = Solve(rooks);
        Message($"{row}, {col}");
    }

    
}
