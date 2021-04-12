import qsharp

from QCHack.Part2 import Solve, ConvertRooksToBitString, testRookOracle, testPhaseOracle

rooks = [(0,0), (1,1), (2,2)]
answer = Solve(rooks=rooks)
print(answer)

# binary = ConvertRooksToBitString(dim=4, bits=4, rooks=rooks)
# print(binary)  

# testRookOracle.simulate(rook=[False,False,True,False], inputstring=[False,False,True,True])

# coords = (0,3)
# testPhaseOracle.simulate(rooks=rooks, coords=coords)