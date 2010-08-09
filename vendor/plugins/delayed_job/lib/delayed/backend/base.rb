module Delayed
  module Backend
    class DeserializationError < StandardError
    end

    module Base
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        # Add a job to the queue
        def enqueue(*args)
          object = args.shift
          unless object.respond_to?(:perform)
            raise ArgumentError, 'Cannot enqueue items which do not respond to perform'
          end
    
          priority = args.first || 0
          run_at   = args[1]
          self.create(:payload_object => object, :priority => priority.to_i, :run_at => run_at)
        end
        
        # Hook method that is called before a new worker is forked
        def before_fork
        end
        
        # Hook method that is called after a new worker is forked
        def after_fork
        end
        
        def work_off(num = 100)
          warn "[DEPRECATION] `Delayed::Job.work_off` is deprecated. Use `Delayed::Worker.new.work_off instead."
          Delayed::Worker.new.work_off(num)
        end
      end
      
      ParseObjectFromYaml = /\!ruby\/\w+\:([^\s]+)/

      def failed?
        failed_at
      end
      alias_method :failed, :failed?

      def name
        @name ||= begin
          payload = payload_object
          payload.respond_to?(:display_name) ? payload.display_name : payload.class.name
        end
      end

      def payload_object=(object)
        self.handler = object.to_yaml
      end
      
      def payload_object
        @payload_object ||= YAML.load(self.handler)
      rescue TypeError, LoadError, NameError => e
          raise DeserializationError,
            "Job failed to load: #{e.message}. Try to manually require the required file. Handler: #{handler.inspect}"
      end

      # Moved into its own method so that new_relic can trace it.
      def invoke_job
        payload_object.perform
      end
      
      # Unlock this job (note: not saved to DB)
      def unlock
        self.locked_at    = nil
        self.locked_by    = nil
      end
      
    protected

      def set_default_run_at
        self.run_at ||= self.class.db_time_now
      end
    
    end
  end
end