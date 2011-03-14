class AssemblyObserver < ActiveRecord::Observer
  def after_create(assembly)
    Rails.logger.info "Queing up assembly #{assembly.assembly_url} (id ##{assembly.id})..."
    AssemblyProcessor.delay.process(assembly)
  end
end
