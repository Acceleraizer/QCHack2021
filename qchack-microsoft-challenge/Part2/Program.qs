namespace QCHack.Part2 {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Measurement;
    
    
    operation RookOracle(
        rook : Bool[], 
        inputs : Qubit[], 
        output: Qubit
    ) : Unit is Adj {
        // Default value: cell is safe
        X(output);
        // Flip output if input is same column as rook
        within {
            for i in 0..1 {
                if (not rook[i]) {
                    X(inputs[i]);
                }
            }
        } apply {
            CCNOT(inputs[0],inputs[1], output);
        }
        // Flip output if input is same row as rook
        within {
            for i in 2..3 {
                if (not rook[i]) {
                    X(inputs[i]);
                }
            }
        } apply {
            CCNOT(inputs[2],inputs[3], output);
        }
        // Flip back if input is the same cell as the rook
        (ControlledOnBitString(rook, X))(inputs, output);
    }

    operation PhaseOracle (
        rooksB : Bool[][], 
        searchRegister : Qubit[], 
        rookAnc : Qubit[],
        oracleAnc : Qubit
    ) : Unit is Adj {
        for r in 0..Length(rooksB)-1 {
            RookOracle(rooksB[r], searchRegister, rookAnc[r]);
        }
        within {
            // X(oracleAnc);
            // H(oracleAnc);
        } apply {
            Controlled X(rookAnc, oracleAnc);
        }
       
    }

    operation Grover (
        rooksB : Bool[][], 
        searchRegister : Qubit[], 
        rookAnc : Qubit[],
        oracleAnc : Qubit,
        phaseOracle : ((Bool[][], Qubit[], Qubit[], Qubit) => Unit is Adj),
        iterations : Int
    ) : Unit is Adj {
        ApplyToEachA(H, searchRegister);
        for it in 1..iterations {
            phaseOracle(rooksB, searchRegister, rookAnc, oracleAnc);

            within {
                ApplyToEachA(H, searchRegister);
                ApplyToEachA(X, searchRegister);
            } apply {
                Controlled Z(Most(searchRegister), Tail(searchRegister));
            }
        }
        

    }

    // Converts the coordinates of the rooks into a bitstring representation
    function ConvertRooksToBitString (dim : Int, bits : Int, rooks : (Int,Int)[]) : Bool[][] {
        mutable coordinates = new Bool[][0];
        for (row, col) in rooks {
            set coordinates += [IntAsBoolArray(row + dim*col, bits)];
        }
        return coordinates;

    }

    // Currently only supports dimensions of a power of 2
    operation Solve (
        rooks : (Int, Int)[]        
    ) : (Int, Int) {
        // The board will have length 1 larger than the number of rooks
        let dim = Length(rooks)+1;
        // Number of qubits needed to represent coordinates
        let bits = Ceiling(Lg(IntAsDouble(dim*dim)));

        // Initialize qubits
        // Search register will store coordinates of all candidate safe spots
        // rookAnc will store the results of RookOracle which checks whether a particular rook attacks a cell
        // oracleAnc combines the results from rookAnc - a cell is safe if and only if it is not attacked by any rook
        use fullRegister = Qubit[bits+dim];
        let searchRegister = fullRegister[0..bits-1];
        let rookAnc = fullRegister[bits..bits+dim-2];
        let oracleAnc = fullRegister[bits+dim-1];
        H(oracleAnc);
        Z(oracleAnc);

        // Convert the coordinates of the rooks into a bitstring
        let rooksB = ConvertRooksToBitString(dim, bits, rooks);

        // The optimal number of iterations to run Grovers for
        let iterations = Round(PI() / 4.0 * Sqrt(IntAsDouble(dim*dim)));
        
        // Run Grover's algorithm
        Grover(rooksB, searchRegister, rookAnc, oracleAnc, PhaseOracle, iterations);

        // Check the states of the output
        // DumpMachine();

        // Measure the amplified state, and convert back into cartesian coordinates.
        let answer = MultiM(searchRegister);
        let integerPosition = ResultArrayAsInt(answer);
        let (row,col) = (integerPosition%dim, integerPosition/dim);

        ResetAll(fullRegister);
        // Message($"The safe spot is on ({row}, {col})");
        return (row,col);        
    }

    operation SolveMultiple (
        rooks : (Int, Int)[],
        count : Int
    ) : (Int,Int)[] {
        mutable results = new (Int, Int)[0];
        for i in 0..count-1 {
            set results += [Solve(rooks)];
        } 
        return results;
    }
}
