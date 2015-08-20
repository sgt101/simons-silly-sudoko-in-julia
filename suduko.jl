module suduko 
using Base.Dates

row1 = [0,0,0,0,0,0,0,7,0]
row2 = [0,4,0,2,9,1,8,6,5]
row3 = [8,5,0,0,0,0,0,0,9]
row4 = [4,0,8,6,0,0,2,0,0]
row5 = [3,2,0,0,4,0,0,8,6]
row6 = [0,0,1,0,0,9,4,0,3]
row7 = [1,0,0,0,0,0,0,9,8]
row8 = [5,8,4,9,6,3,0,2,0]
row9 = [0,6,0,0,0,0,0,0,0]
p1=[0,7,0,9,6,4,0,0,0]
p2=[0,3,0,1,0,0,0,4,6]
p3=[0,0,0,8,0,0,0,0,5]
p4=[0,2,0,0,0,0,0,0,3]
p5=[6,0,0,0,0,0,0,0,4]  
p6=[4,0,0,0,0,0,0,9,0]
p7=[1,0,0,0,0,3,0,0,0]
p8=[3,9,0,0,0,5,0,1,0]
p9=[0,0,0,7,1,6,0,5,0]
#array = hvcat (9,row1,row2,row3,row4,row5,row6,row7,row8,row9)
array =hvcat(9,p1,p2,p3,p4,p5,p6,p7,p8,p9)
type CandidateSet{T}
    rx::Int
    ry::Int
    candidates::Array{T}
end


function howManySquares(matrix::Array)
    count = 0
    for thing in matrix
        if thing==0 count+=1     
        end
    end
    #if (count <3) println(matrix) end
    return count
end

function generateCandidates (rx::Int,ry::Int, matrix::Array)
    starter=CandidateSet(rx,ry,Int[0])
    if matrix [rx,ry]!=0 
        return starter #because we don't need a candidate
	#not good code - need to think of a way to just not have this value
    else
    allMembers = rowColumnBlock(rx,ry,matrix)
   # print (allMembers)
    elements=Int[]
    for i in 1:9 
        if !in(i,allMembers)
            push!(elements,i)
        end
    end
  
    if (elements==[])
        throw (DomainError()) # because this is an matrix with a contradiction not yet discovered
        end
          candidate=CandidateSet(rx,ry,elements)
    return candidate
    end
end


function createCandidateMatrix (things::Array)
    matrix = CandidateSet[]
    for n in 1:9 
        for m in 1:9
            candidates = generateCandidates (m,n,things)
                push!(matrix,candidates)
            end
    end
    matrix2 = reshape (matrix,9,9)
   #@show(matrix2)
    return (matrix2)
end

#extract relevant elements for considering a square in suduko 
function rowColumnBlock (rx::Int, ry::Int, matrix::Array)
   # matrix[rx,ry] = 0
  row = matrix[rx,:]
    column = matrix[:, ry]
    x1 = div(rx-1,3)*3
    y1 = div(ry-1,3)*3
    x2=x1+3
    y2=y1+3
    x1+=1
    y1+=1
   # @show x1,x2,y1,y2
    block = matrix[x1:x2,y1:y2]
    #=we've got the row, column and block so now
    get membership and see if there's a missing one =#
    allMembers = [reshape(block,1,9);reshape(column,1,9);reshape(row,1,9)]
    return allMembers
end

function exclusiveRowColumnBlock(rx::Int, ry::Int, matrix::Array)
    value = matrix[rx,ry]
    matrix[rx,ry] = 0
    retval = rowColumnBlock(rx,ry,matrix)
    matrix[rx,ry] = value
    return retval
end

function copytx (matrix::Array{Int})
    retval = Array (Int,length(matrix))
    for i in 1:length (matrix)
        retval[i] = matrix[i]
        end
        return reshape (retval,9,9)
        end
        


function notConsistent (matrix::Array)
    copyt = copytx(matrix)
    for n in 1:9
        for m in 1:9 
        if (matrix[n,m]!=0)
          copyt[n,m]=10
          row = copyt[n,:]
          if (in(matrix[n,m],row))
            #print ("not consistent")
            return (true)
            end
          column = copyt[:, m]
          if (in(matrix[n,m],column))
            #print ("not consistent")
            return (true)
          end
         x1 = div(n-1,3)*3
        y1 = div(m-1,3)*3
        x2=x1+3
        y2=y1+3
        x1+=1
        y1+=1
   # @show x1,x2,y1,y2
        block = copyt[x1:x2,y1:y2]
        if (in(matrix[n,m],block))
            #print ("not consistent")
            return (true)
        end #if
        copyt [n,m] = matrix[n,m]
        end #for
        end #for
    end #if
    return false 
    end



    

function solutionSearch( matrix::Array, depth::Int)
	# for every element in matrix which is a 0 (undefined) look
	# at all the other 0s to find any that contain exclusions
	# which can solve this square
	# check singles and pairs only for now !
    try 
	touched = false
	newMatrix = Int[]
	candidateSet = createCandidateMatrix(matrix)
	if (notConsistent(matrix)) 
	 #print ("not consistent")
	return false
	else 
	for i in 1:81
	    if (matrix[i]==0 ) #something to do
	       if (length(candidateSet[i].candidates)==1)
	       	  #simple write in
	       	  matrix[i]=candidateSet[i].candidates[1]
	       	#  println("i=",i,"val=",matrix[i])
		   #   candidateSet[i].candidates=[]
		      if (notConsistent(matrix))
		          return false 
		      end #unwind as this is a dead attempt 
		      touched = true
		     # println("MA>>",matrix[i])
		  end #end if
		end #end if
	end	#end for      
	candidateSet=createCandidateMatrix(matrix) #in case a repair was needed
    tries = zeros(9,9)
    marktries(tries,matrix)
    while (!complete (tries)) 
    index = shortest(candidateSet,tries)
    for guess in candidateSet[index].candidates
	          #= for every option try writing it in and then solving the matrix with that assumption
	          if a contradiction arises then stop and unwind and try a different option =#     	    
		      newMatrix = copytx(matrix)
		      newMatrix[index] =guess
		      if(!notConsistent (newMatrix))
		          if(solutionSearch (newMatrix,depth+1))
                    touched = true
                    matrix = newMatrix
                   end
              else
                matrix[index] = 0
              end#if 
                cache2= newMatrix
            end #for
            tries [index]=1
	   end #while
	  end #else
	 # end
	 if(rem(datetime2unix(now()),10)==0.0)
	   println(matrix)
	   end
	  if (howManySquares(matrix)==0)
	   println(matrix)
	   toc
	   exit()
	   end
	  if (depth<2) println(matrix)
	  return (touched)
	  end
	  
 catch (e)
    #println(e)
  return false
  end
 end

bestSoFar =81

function marktries(tries::Array,tester::Array)
    for i in 1:length(tester)
        if (tester[i]!=0) 
            tries[i]=1 
        end#if
    end#for
end
        
 function complete (tries::Array)
    if (in(0,tries)) 
        return false 
    else
    return true
    end
end
    
 function shortest (candidates::Array{CandidateSet}, tries::Array)
    theOne =0 
    for i in 1:length(candidates)
       if (tries[i]==0.0)
       if candidates[i].candidates[1]!=0 # there is a list
       if (theOne==0)
        theOne=i else
        if (length(candidates[i].candidates) < length(candidates[theOne].candidates))
            theOne = i
        end #if
        end #else
        end #if
    end #if
    end #for
    return theOne
end       
           
cache= []
cache2 = []

 function cleanArray(thing::Int,target::Array)
    retVal =Int[]
    if (length(target)==1) return [0] end
  #  print ("starting>>", target)
    for i = 1:length(target)
        if target[i]!=thing 
            push!(retVal,target[i])
        end
    end
   #         print ("done >> ",retVal)
    return retVal
    end

function hypothesis (guess::Int, tester::Array{CandidateSet})
  #print (tester)
  for i in tester 
    if in (guess,i.candidates)	
    return (false)
    end
    end
    return (true)
end
    tic
    #candidates = createCandidateMatrix(array)
    solutionSearch (array,0)
    print (cache,"\n")
    print (cache2,"\n")


end #module