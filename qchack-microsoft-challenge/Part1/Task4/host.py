import qsharp

from QCHack.Task4 import FindTriangles, TestFindTriangles, TestTask

# V=5
# edges=[(0,1),(1,2),(2,0),(0,3),(3,4),(1,3)]
# colors=[True,True,True,False,False,False]

V=3
edges=[(0,1),(1,2),(2,0)]
colors=[True,True,True]

TestFindTriangles.simulate(V=V,edges=edges)


# TestTask.simulate(V=V,edges=edges,colors=colors)