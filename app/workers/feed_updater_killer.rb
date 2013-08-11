# for every feed updater, there's a killer
class FeedUpdaterKiller
  @queue = :feed_updater_queue
  def self.perform
      logger = Rails.logger
      logger.info "Thrill to kill at #{Time.now}.\n"

      `sudo ps -e -o pid,command | grep [r]esque`.split("\n").each do |line|
        parts   = line.split(' ')
        started = parts[-2].to_i
        next if started == 0
        elapsed = (Time.now - Time.at(started)) / 60

        if elapsed >= WORKER_TIMEOUT
          ::Process.kill('KILL', parts[0].to_i)
          logger.info "Killed one at #{Time.now}.\n"
        end
      end
  end
end
