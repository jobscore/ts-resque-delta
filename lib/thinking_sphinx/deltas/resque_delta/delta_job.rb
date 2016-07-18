# A simple job class that processes a given index.
#
class ThinkingSphinx::Deltas::ResqueDelta::DeltaJob
  @queue = :ts_delta

  # Runs Sphinx's indexer tool to process the index. Currently assumes Sphinx
  # is running.
  #
  # @param [String] index the name of the Sphinx index
  #
  def self.perform(index)
    cancel_equal_index_jobs(index)
    ThinkingSphinx::Deltas::IndexJob.new(index).perform
  end

  def self.cancel_equal_index_jobs(index)
    Resque.redis.lrem "queue:#{@queue}", 0, "{\"class\":\"ThinkingSphinx::Deltas::ResqueDelta::DeltaJob\",\"args\":[\"#{index}\"]}"
  end
end
