class AssemblyObserver < ActiveRecord::Observer
  def after_create(assembly)
    Rails.logger.info "Processing assembly #{assembly.assembly_url} (id ##{assembly.id})"
    AssemblyProcessor.process(assembly)
    Rails.logger.info "Finished processing assembly #{assembly.assembly_url} (id ##{assembly.id})"
  rescue ChiliVideoPlugin::Error::IncompleteAssembly
    Rails.logger.info "Assembly #{assembly.assembly_url} (id ##{assembly.id}) is not completed yet. Requeing for processing..."
    AssemblyProcessor.delay.process(assembly)
  end
end
