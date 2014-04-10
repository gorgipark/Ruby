#Rest client test
require 'rest_client'
require 'json'


exitll = false

def repeat_every(interval)
    Thread.new do
        loop do
            start_time = Time.now
            yield
            elapsed = Time.now - start_time
            sleep([interval - elapsed, 0].max)
            
        end
    end
end

def saveRecord (rec)
    begin
       
        t=Time.now
        
        if File.exists?("test.csv") == false
             file = File.open("test.csv", "a")
            file.puts("Time,Ambient,IR,dt,cloud")
        elsif
             file = File.open("test.csv", "a")
             str = "%s,%f,%f,%f,%f" %[t,rec["Ambient"],rec["IR"],rec["Dt"],rec["cloud"]]
             file.puts (str)
        end
        rescue IOError => e
        #some error occur, dir not writable etc.
        ensure
        file.close unless file == nil
    end
end

#------------------------------------------------

postreturn = ""
impreading =""

thread = repeat_every(3) do
    
  begin
        postreturn =RestClient.post 'https://agent.electricimp.com/DESxRMae91mQ', :param1 => 'one'
        
        puts "RC: #{postreturn.code} - %s" %Time.now
        
        if postreturn.code == 200
            impreading = JSON.parse postreturn
            saveRecord impreading
        end
  rescue => e
        e.response
  end

 
end

thread.join




