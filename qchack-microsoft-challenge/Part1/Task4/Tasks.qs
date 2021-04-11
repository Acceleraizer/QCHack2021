namespace QCHack.Task4 {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;

    // Task 4 (12 points). f(x) = 1 if the graph edge coloring is triangle-free
    // 
    // Inputs:
    //      1) The number of vertices in the graph "V" (V ≤ 6).
    //      2) An array of E tuples of integers "edges", representing the edges of the graph (0 ≤ E ≤ V(V-1)/2).
    //         Each tuple gives the indices of the start and the end vertices of the edge.
    //         The vertices are indexed 0 through V - 1.
    //         The graph is undirected, so the order of the start and the end vertices in the edge doesn't matter.
    //      3) An array of E qubits "colorsRegister" that encodes the color assignments of the edges.
    //         Each color will be 0 or 1 (stored in 1 qubit).
    //         The colors of edges in this array are given in the same order as the edges in the "edges" array.
    //      4) A qubit "target" in an arbitrary state.
    //
    // Goal: Implement a marking oracle for function f(x) = 1 if
    //       the coloring of the edges of the given graph described by this colors assignment is triangle-free, i.e.,
    //       no triangle of edges connecting 3 vertices has all three edges in the same color.
    //
    // Example: a graph with 3 vertices and 3 edges [(0, 1), (1, 2), (2, 0)] has one triangle.
    // The result of applying the operation to state (|001⟩ + |110⟩ + |111⟩)/√3 ⊗ |0⟩ 
    // will be 1/√3|001⟩ ⊗ |1⟩ + 1/√3|110⟩ ⊗ |1⟩ + 1/√3|111⟩ ⊗ |0⟩.
    // The first two terms describe triangle-free colorings, 
    // and the last term describes a coloring where all edges of the triangle have the same color.
    //
    // In this task you are not allowed to use quantum gates that use more qubits than the number of edges in the graph,
    // unless there are 3 or less edges in the graph. For example, if the graph has 4 edges, you can only use 4-qubit gates or less.
    // You are guaranteed that in tests that have 4 or more edges in the graph the number of triangles in the graph 
    // will be strictly less than the number of edges.
    //
    // Hint: Make use of helper functions and helper operations, and avoid trying to fit the complete
    //       implementation into a single operation - it's not impossible but make your code less readable.
    //       GraphColoring kata has an example of implementing oracles for a similar task.
    //
    // Hint: Remember that you can examine the inputs and the intermediary results of your computations
    //       using Message function for classical values and DumpMachine for quantum states.
    //

    function FindTriangles (V : Int, edges : (Int,Int)[]) : (Int,Int,Int)[] {
        // boolean array of length V*V where isedge[(a-1)+V*(b-1)] indicates if edge (a,b) is present 
        mutable isedge = new (Int)[V*V];
        for (i in 0..Length(edges)-1) {
            let (a,b) = edges[i];
            set isedge w/=  MinI(a,b) + V*MaxI(a,b) <- i+1;
        }

        mutable counter = 0;
        mutable triangles = new (Int,Int,Int)[0];

        for (i in 0 .. V-1) {
            for (j in i+1 .. V-1) {
                for (k in j+1 .. V-1) {
                    if (isedge[i+V*j]>0 and isedge[i+V*k]>0 and isedge[j+V*k]>0) {
                        set triangles += [(isedge[i+V*j]-1,isedge[i+V*k]-1,isedge[j+V*k]-1)];
                        set counter += 1;
                        // Message($"{i} {j} {k}");
                    }
                }
            }
        }
        return triangles;
    }

    operation TestFindTriangles (V : Int, edges : (Int,Int)[]) : Unit {
        let result=FindTriangles(V, edges);
        for ((a,b,c) in result) {
            Message($"Triangle : {a} {b} {c}");
        }
    }

    operation ValidTriangle (inputs : Qubit[], output : Qubit) : Unit is Adj+Ctl {
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


    operation Task4_TriangleFreeColoringOracle (
        V : Int, 
        edges : (Int, Int)[], 
        colorsRegister : Qubit[], 
        target : Qubit
    ) : Unit is Adj+Ctl {
        // ...
        let triangles = FindTriangles(V, edges);
        let n = Length(triangles);
        if (n == 0) {
            X(target);
        } else {
            use anc = Qubit[n];
            within {
                for (i in 0..n-1) {
                    let (v1,v2,v3) = triangles[i];
                    Message($"Triangle: {v1} {v2} {v3}");
                    let subreg = Subarray([v1,v2,v3], colorsRegister);
                    ValidTriangle(subreg, anc[i]);
                }
            } apply {
                Controlled X(anc, target);
                DumpRegister((), colorsRegister+anc+[target]);
                // X(target);
            }
        }
        
    }

    operation TestTask (
        V : Int, 
        edges : (Int, Int)[], 
        colors : Bool[]
    ) : Unit {
        let e = Length(edges);
        // use colorsRegister = Qubit[e];
        // for (i in 0..e-1) {
        //     if (colors[i]) {
        //         X(colorsRegister[i]);
        //     }
        // }
        // use target = Qubit();
        // Task4_TriangleFreeColoringOracle(V, edges, colorsRegister, target);
        // DumpMachine();
    }
}

