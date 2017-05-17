require 'net/ip'

class IpsecRouter
  def initialize(local_lan)
    @local_lan = local_lan
  end

  def route
    run_rules('I')
  end

  def unroute
    run_rules('D')
  end

  private

  def run_rules(action)
    routes.each do |route|
      prefix = route[:prefix]
      src = route[:src]
      `sudo iptables -t nat -#{action} POSTROUTING -s #{@local_lan} -d #{prefix} -j SNAT --to-source=#{src}`
    end
  end

  def routes
    Net::IP.routes(220).map(&:to_h)
  end
end

IpsecRouter.new(ARGV[1]).send(ARGV[0].to_sym)
