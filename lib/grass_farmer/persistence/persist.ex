defprotocol GrassFarmer.Persist do
  def local_write(adapter) # this saves the data memory - it will not persist across restarts
  def local_read(adapter) # this loads the data from memory
  def save(adapter) # saves all the data to the persistence layer - only works in prod mode on the target device
  def load(adapter) # loads all the data from the persistence layer - only works in prod mode on the target device
end
