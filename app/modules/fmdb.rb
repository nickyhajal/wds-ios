module Fmdb
  def fmdb
    _db = FMDatabase.databaseWithPath(File.join(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0], 'wds.db'))
    _db.crashOnErrors = true
    _db.open
    # if !_db.open
    #   _db.release
    # end
    _db
  end
end