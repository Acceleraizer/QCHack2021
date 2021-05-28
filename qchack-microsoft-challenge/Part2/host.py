import qsharp

from QCHack.Part2 import Solve, SolveMultiple, ConvertRooksToBitString, testRookOracle, testPhaseOracle

def printresults(hist, rooks):
    print("#"*(5+7*4))
    for r in range(4):
        for c in range(4):
            if (r,c) in rooks:
                print("#"*8, end ="")
            else:
                print((("#")+" "*7), end ="")
        print ("#")
        for c in range(4):
            v = hist[(r,c)]
            if v<0.1:
                print(f"#  {round(v*100,2)}% ", end ="")
            else: 
                print(f"# {round(v*100,2)}% ", end ="")
        print ("#")
        for c in range(4):
            if (r,c) in rooks:
                print("#"*8, end ="")
            else:
                print((("#")+" "*7), end ="")
        print ("#")
        print("#"*(5+7*4))


def main():
    rooks = [(0,0), (1,3), (2,2)]
    count = 200
    answers = SolveMultiple(rooks=rooks, count=count)
    hist = dict([((i,j), 0) for i in range(4) for j in range(4)])
    for answer in answers:
        hist[answer] += 1/count

    printresults(hist, rooks)


if __name__ == "__main__":
    main()