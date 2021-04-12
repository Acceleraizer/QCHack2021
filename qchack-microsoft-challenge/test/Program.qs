namespace TestQ {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    
    operation SayHello() : Result {
        Message($"Hi");
        let a = 1+1;
        mutable m = Zero;
        using (anc = Qubit()) {
            X(anc);
            set m = M(anc);
            Message($"{m}");
            Message($"{a}");
            Reset(anc);
        }
        return m;
    }
}
