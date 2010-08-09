
# ruby 1.8.6にHash#firstが無いので自前実装
unless Hash.method_defined?('first')
  class Hash
    def first
      key = self.keys.first
      [key, self.fetch(key)]
    end
  end
end
