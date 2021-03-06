module Hopper
  class Containers < Probe
    # The data for this Probe.
    exposes :classes_count, :modules_count

    # The description.
    #
    # Returns a String.
    def self.description
      "Modules and Classes, oh my."
    end

    # The total number of classes defined.
    #
    # Returns an Integer.
    def classes_count
      repository.files(:pattern => /.rb/).map do |file|
        parse_file(file,:class)
      end.sum
    end

    # The total number of modules defined.
    #
    # Returns an Integer.
    def modules_count
      repository.files(:pattern => /.rb/).map do |file|
        parse_file(file,:module)
      end.sum
    end

    # Does this project define multiple classes or modules in a file?
    #
    # Returns a binary integer.
    def multiple_per_file
      binary_integer repository.files(:pattern => /.rb/).map do |file|
        content = repository.read(file)
        parsed = Ripper.sexp(content)

        if parsed.count(:module) > 1 || parsed.count(:class) > 1
          1
        else
          0
        end
      end
    end

  private
    def parse_file(file,object)
      content = repository.read(file)
      parsed = Ripper.sexp(content)

      !parsed ? 0 : parsed.flatten.count(object)
    rescue Exception => e
      0
    end
  end
end