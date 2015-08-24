"trying to demonstrate an unwanted behaviour in Julia"

function makeRand ()
    thing::Int = randomDevice()
    throw (BoundsError()) 
    return (thing)
    end
    
    
function checker (number::Int)
    done=0
    try 
        while ((rem(makeRand(),100)!=0)&&done==0)
          done=1
          print("done")
          return (true)
        end 
            print ("not")         
            return (false)
        catch e
        println (e)
        return(true)
    end   
end
                   