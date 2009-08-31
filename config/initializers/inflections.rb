# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

Analyzer = RMMSeg::Ferret::Analyzer.new { |tokenizer|  
   Ferret::Analysis::LowerCaseFilter.new(tokenizer)  
}         

ActiveScaffold.set_defaults do |config|
  config.security.current_user_method = :current_user
  #config.security.default_permission = false

end 

WillPaginate::ViewHelpers.pagination_options[:previous_label] = '<<'   
WillPaginate::ViewHelpers.pagination_options[:next_label] = '>>' 

TagList.delimiter = " "
                                 
# speed up ferret index

class Ferret::Index::Index

  def update_batch(docs)
    @dir.synchrolock do
      ensure_writer_open()
      commit = false
      docs.each do |id, value|
        delete(id)
        commit = true if id.is_a?(String) or id.is_a?(Symbol)
      end
      if commit
        @writer.commit
      end
      ensure_writer_open()
      docs.each do |id, new_doc|
        @writer << new_doc
      end
      flush() if @auto_flush
    end
  end

end

class ActsAsFerret::BulkIndexer

  def index_records(records, offset)
    docs = {}
    batch_time = measure_time {
      records.each { |rec| docs[rec.id] = rec.to_doc if rec.ferret_enabled?(true) }
      @index.update_batch(docs)
    }.to_f
    @work_done = offset.to_f / @model_count * 100.0 if @model_count > 0
    remaining_time = ( batch_time / @batch_size ) * ( @model_count - offset + @batch_size )
    @logger.info "#{@reindex ? 're' : 'bulk '}index model #{@model.name} : #{'%.2f' % @work_done}% complete : #{'%.2f' % remaining_time} secs to finish"

  end

end
             

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :default => "%Y-%m-%d",
  :date_edu => "%m/%Y",
  :date_time12 => "%m/%d/%Y %I:%M%p",
  :date_time24 => "%m/%d/%Y %H:%M"
)
