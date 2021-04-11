namespace QCHack.Task3 {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    // Task 3 (5 points). f(x) = 1 if at least two of three input bits are different - hard version
    //
    // Inputs:
    //      1) a 3-qubit array "inputs",
    //      2) a qubit "output".
    // Goal: Implement a marking oracle for function f(x) = 1 if at least two of the three bits of x are different.
    //       That is, if both inputs are in a basis state, flip the state of the output qubit 
    //       if and only if the three bits written in the array "inputs" have both 0 and 1 among them,
    //       and leave the state of the array "inputs" unchanged.
    //       The effect of the oracle on superposition states should be defined by its linearity.
    //       Don't use measurements; the implementation should use only X gates and its controlled variants.
    //       This task will be tested using ToffoliSimulator.
    // 
    // For example, the result of applying the operation to state (|001⟩ + |110⟩ + |111⟩)/√3 ⊗ |0⟩
    // will be 1/√3|001⟩ ⊗ |1⟩ + 1/√3|110⟩ ⊗ |1⟩ + 1/√3|111⟩ ⊗ |0⟩.
    //
    // In this task, unlike in task 2, you are not allowed to use 4-qubit gates, 
    // and you are allowed to use at most one 3-qubit gate.
    // Warning: some library operations, such as ApplyToEach, might count as multi-qubit gate,
    // even though they apply single-qubit gates to separate qubits. Make sure you run the test
    // on your solution to check that it passes before you submit the solution!
    operation Task3_ValidTriangle (inputs : Qubit[], output : Qubit) : Unit is Adj+Ctl {
        // ...
        X(output);
        within {
            CNOT(inputs[2],inputs[1]);
            CNOT(inputs[2],inputs[0]);
            X(inputs[0]);
            X(inputs[1]);
        } apply {
            CCNOT(inputs[0], inputs[1], output);
        }
    }
}

