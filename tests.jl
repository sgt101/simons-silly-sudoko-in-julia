using Base.Test
using suduko
p1=[0,7,0,9,6,4,0,0,0]
p2=[0,3,0,1,0,0,0,4,6]
p3=[0,0,0,8,0,0,0,0,5]
p4=[0,2,0,0,0,0,0,0,3]
p5=[6,0,0,0,0,0,0,0,4]  
p6=[4,0,0,0,0,0,0,9,0]
p7=[1,0,0,0,0,3,0,0,0]
p8=[3,9,0,0,0,5,0,1,0]
p9=[0,0,0,7,1,6,0,5,0]

tester=hvcat(9,p1,p2,p3,p4,p5,p6,p7,p8,p9)
print ("in tester")
print(suduko.notConsistent (tester));
print ("done")

p1=[7,7,7,9,6,4,0,0,0] #this is not consistent
p2=[7,3,0,1,0,0,0,4,6]
p3=[0,0,0,8,0,0,0,0,5]
p4=[0,2,0,0,0,0,0,0,3]
p5=[6,0,0,0,0,0,0,0,4]  
p6=[4,0,0,0,0,0,0,9,0]
p7=[1,0,0,0,0,3,0,0,0]
p8=[3,9,0,0,0,5,0,1,0]
p9=[0,0,0,7,1,6,0,5,0]

tester=hvcat(9,p1,p2,p3,p4,p5,p6,p7,p8,p9)

println("in tester")
print (suduko.notConsistent(tester))
print ("done")