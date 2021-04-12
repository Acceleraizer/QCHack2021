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
    // @Test("Microsoft.Quantum.Katas.CounterSimulator")
    // operation TestDiagonalRooks () : Unit {
    //     let rooks = [(0,0), (1,1), (2,2)];
    //     let (row, col) = Solve(rooks);
    //     Message($"{row}, {col}");
    // }

    operation testRookOracle (rook : Bool[], inputstring : Bool[]) : Unit {
        using (reg = Qubit[5]) {
            for (i in 0..3) {
                if (inputstring[i]) {
                    X(reg[i]);
                }
            }
            RookOracle(rook, reg[0..3], reg[4]);
            let m = M(reg[4]);
            ResetAll(reg);
            Message($"Rook: {rook}, pos: {inputstring}, result: {m}");
        }
    }

    operation testPhaseOracle (rooks : (Int,Int)[], coords : (Int,Int)) : Unit {
        using (reg = Qubit[8]) {
            let coordsB = ConvertRooksToBitString(4, 4, [coords]);
            for (i in 0..3) {
                if (coordsB[0][i]) {
                    X(reg[i]);
                }
            }
            let rooksB = ConvertRooksToBitString(4, 4, rooks);
            
            PhaseOracle(rooksB, reg[0..3], reg[4..6], reg[7]);
            let m = M(reg[7]);
            ResetAll(reg);
            Message($"Rooks: {rooks}, pos: {coords}, result: {m}");
        }
    }
}
