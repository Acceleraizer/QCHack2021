namespace TestQ {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    
    // @EntryPoint()
    operation SayHello() : Unit {
        Message($"Hi");
        let a = 1+1;
        use anc = Qubit();
        X(anc);
        let m = M(anc);
        Message($"{m}");
        Message($"{a}");
    }
}
