module ActiveScaffold
  module Bridges
    def self.bridge(name, &block)
      ActiveScaffold::Bridges::Bridge.new(name, &block)
    end
    
    class Bridge
      attr_accessor :name
      cattr_accessor :bridges
      cattr_accessor :bridges_run
      self.bridges = []
      
      def initialize(name, &block)
        self.name = name
        @install = nil
        # by convention and default, use the bridge name as the required constant for installation
        @install_if = lambda { Object.const_defined?(name) }
        self.instance_eval(&block)
        
        ActiveScaffold::Bridges::Bridge.bridges << self
      end
      
      # Set the install block
      def install(&block)
        @install = block
      end
      
      # Set the install_if block (to check to see whether or not to install the block)
      def install?(&block)
        @install_if = block
      end
      
      
      def run
        raise(ArgumentError, "install and install? not defined for bridge #{name}" ) unless @install && @install_if
        @install.call if @install_if.call
      end
      
      def self.run_all
        return false if self.bridges_run
        ActiveScaffold::Bridges::Bridge.bridges.each{|bridge|
          bridge.run
        }
        self.bridges_run=true
      end
    end
  end
end

require File.join(File.dirname(__FILE__), 'shared', 'date_bridge.rb')
Dir[File.join(File.dirname(__FILE__), "*/bridge.rb")].each{|bridge_require|
  load_bridge = true
  unless ActiveScaffold.exclude_bridges.empty?
    match = bridge_require.match('bridges\/(.*)\/bridge.rb')
    bridge_name = match[1] ? match[1] : nil
    load_bridge = ActiveScaffold.exclude_bridges.exclude?(bridge_name.to_sym) if bridge_name
  end
  require bridge_require if load_bridge == true
} 