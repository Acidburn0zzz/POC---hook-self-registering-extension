module Hook
  module_function

  # Trigger the call of method defined by 'with' on defined object 'on'
  # with parameter the child that inherited defined 'baseclass'.
  #
  # @param callback [Symbol] callback triggering
  # @param on [Class] baseclass to watch callback on
  # @param to [Object] target object
  # @param with [Symbol] target object's method name
  def call(callback, on:, to:, with:)
    hook = Module.new
    hook.send(:define_method, callback) { |child|
      super child
      to.send with, child
    }

    on.extend hook
    nil
  end
end
