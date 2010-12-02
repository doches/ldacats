class LDACats
	attr_reader :categories

	# Load GibbsLDA++ output from `path_to_output`
	def initialize(path_to_output,partial=nil)
		@input_path = path_to_output

		# Which model iteration (e.g. model-0300, model-final, &c) are we after?
		if partial.nil?
			partial = "model-final"
		end
		@model = partial
		
		# Work
		self.load_wordmap
		self.parse_phi
		self.extract_categories
	end
	
	def load_wordmap
		@word2key = {}
		@key2word = {}
		
		first = true
		IO.foreach(File.join(@input_path,"wordmap.txt")) do |line|
			if first
				first = false
			else
				word,index = *line.strip.split(/\s/)
				word_sym = word.to_sym
				index_int = index.to_i
				
				@word2key[word_sym] = index_int
				@key2word[index_int] = word_sym
			end
		end
	end
	
	def parse_phi
		@topics = []
		IO.foreach(File.join(@input_path,"#{@model}.phi")) do |line|
			topic = {}
			word_probabilities = line.strip.split(/\s/)
			word_probabilities.each_with_index do |probability,word_index|
				word_sym = @key2word[word_index]
				topic[word_sym] = probability.to_f
			end
			@topics.push topic
		end
	end
	
	def extract_categories
		@categories = {}
		@word2key.keys.each do |word_sym|
			probabilities = {}
			@topics.each_with_index do |topic,topic_index|
				probabilities[topic_index] = topic[word_sym]
			end
			if probabilities.reject { |k,v| v.nil? }.size > 0
				best = probabilities.map { |k,v| [k,v] }.sort { |a,b| b[1] <=> a[1] }.shift
				@categories[best[0]] ||= []
				@categories[best[0]].push word_sym
			end
		end
	end
	
	def filter_by_targets(target_words)
		# Parse list of target words, if provided
		@target_symbols = nil
		@target_words = nil
		if not target_words.nil?
			@target_words = IO.readlines(target_words).map { |x| x.strip }
			@target_symbols = @target_words.map { |x| x.to_sym }
		end
		
		new_categories = {}
		@categories.each_pair do |k,v|
			new_categories[k] = v.reject { |x| not @target_symbols.include?(x) }
		end
		
		return new_categories
	end
end
